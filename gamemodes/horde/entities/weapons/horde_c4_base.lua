
-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

if SERVER then
	AddCSLuaFile()
end

local CurTime = CurTime
local sp = game.SinglePlayer()

DEFINE_BASECLASS("horde_tfa_gun_base")
SWEP.DrawCrosshair = true
SWEP.Type = "Grenade"
SWEP.MuzzleFlashEffect = ""
SWEP.Secondary.IronSightsEnabled = false
SWEP.Delay = 0.3 -- Delay to fire entity
SWEP.Delay_Underhand = 0.3 -- Delay to fire entity when underhand
SWEP.Primary.Round = "" -- Nade Entity
SWEP.Velocity = 550 -- Entity Velocity
SWEP.Underhanded = false
SWEP.DisableIdleAnimations = true
SWEP.IronSightsPosition = Vector(5,0,0)
SWEP.IronSightsAngle = Vector(0,0,0)
SWEP.Callback = {}

SWEP.AllowUnderhanded = true
SWEP.AllowSprintAttack = true

TFA.AddStatus("C4_DETONATE")
TFA.Enum.IronStatus[TFA.Enum.STATUS_C4_DETONATE] = true

local nzombies = nil

function SWEP:GetBombs()
	local bombs = {}
	local ply = self:GetOwner()
	for _, ent in pairs(ents.FindByClass("horde_c4_exp")) do
		if IsValid(ent) and ent:GetOwner() == ply then
			table.insert(bombs, ent)
		end
	end
	return bombs
end

function SWEP:Initialize()
	if nzombies == nil then
		nzombies = engine.ActiveGamemode() == "nzombies"
	end

	self.ProjectileEntity = self.ProjectileEntity or self.Primary.Round -- Entity to shoot
	self.ProjectileVelocity = self.Velocity or 550  -- Entity to shoot's velocity
	self.ProjectileModel = nil                                          -- Entity to shoot's model

	self:SetNW2Bool("Underhanded", false)

	BaseClass.Initialize(self)
end

function SWEP:Deploy()
	if self:Clip1() <= 0 then
		if self:Ammo1() > 0 then
			self:TakePrimaryAmmo(1, true)
			self:SetClip1(1)
		end
	end

	self:SetNW2Bool("Underhanded", false)

	self.oldang = self:GetOwner():EyeAngles()
	self.anga = Angle()
	self.angb = Angle()
	self.angc = Angle()

	self:CleanParticles()

	return BaseClass.Deploy(self)
end

function SWEP:ChoosePullAnim()
	if not self:OwnerIsValid() then return end

	if self.Callback.ChoosePullAnim then
		self.Callback.ChoosePullAnim(self)
	end

	if self:GetOwner():IsPlayer() then
		self:GetOwner():SetAnimation(PLAYER_RELOAD)
	end

	self:SendViewModelAnim(ACT_VM_PULLPIN)

	if sp then
		self:CallOnClient("AnimForce", ACT_VM_PULLPIN)
	end

	return true, ACT_VM_PULLPIN
end

function SWEP:ChooseShootAnim()
	if not self:OwnerIsValid() then return end

	if self.Callback.ChooseShootAnim then
		self.Callback.ChooseShootAnim(self)
	end

	if self:GetOwner():IsPlayer() then
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	end

	local tanim = self:GetNW2Bool("Underhanded", false) and self.SequenceEnabled[ACT_VM_RELEASE] and ACT_VM_RELEASE or ACT_VM_THROW
	self:SendViewModelAnim(tanim)

	if sp then
		self:CallOnClient("AnimForce", tanim)
	end

	return true, tanim
end

function SWEP:ThrowStart()
	if self:Clip1() <= 0 then return end

	local success, tanim, animType = self:ChooseShootAnim()

	local delay = self:GetNW2Bool("Underhanded", false) and self.Delay_Underhand or self.Delay
	self:ScheduleStatus(TFA.Enum.STATUS_GRENADE_THROW, delay)

	if success then
		self.LastNadeAnim = tanim
		self.LastNadeAnimType = animType
		self.LastNadeDelay = delay
	end
end

function SWEP:Throw()
	if self:Clip1() <= 0 then return end
	self.ProjectileVelocity = (self:GetNW2Bool("Underhanded", false) and self.Velocity_Underhand) or ((self.Velocity or 550) / 1.5)

	self:TakePrimaryAmmo(1)
	self:ShootBulletInformation()

	if self.LastNadeAnim then
		local len = self:GetActivityLength(self.LastNadeAnim, true, self.LastNadeAnimType)
		self:ScheduleStatus(TFA.Enum.STATUS_GRENADE_THROW_WAIT, len - (self.LastNadeDelay or len))
	end
end

function SWEP:Think2(...)
	if not self:OwnerIsValid() then return end

	local stat = self:GetStatus()

	-- This is the best place to do this since Think2 is called inside FinishMove
	self:SetNW2Bool("Underhanded", self.AllowUnderhanded and self:KeyDown(IN_ATTACK2))

	local statusend = CurTime() >= self:GetStatusEnd()

	if stat == TFA.Enum.STATUS_GRENADE_PULL and statusend then
		stat = TFA.Enum.STATUS_GRENADE_READY
		self:SetStatus(stat, math.huge)
	end

	if stat == TFA.Enum.STATUS_GRENADE_READY and (self:GetOwner():IsNPC() or not self:KeyDown(IN_ATTACK2) and not self:KeyDown(IN_ATTACK)) then
		self:ThrowStart()
	end

	if stat == TFA.Enum.STATUS_GRENADE_THROW and statusend then
		self:Throw()
	end

	if stat == TFA.Enum.STATUS_C4_DETONATE then
		self:DetonateC4()
	end
	
	if stat == TFA.Enum.STATUS_IDLE and self:Clip1() <= 0 and self:Ammo1() > 0 and self:GetNextPrimaryFire() <= CurTime() and self.Primary.ClipSize > 0 then
		self:Reload()
	end
	
	return BaseClass.Think2(self, ...)
end

function SWEP:DetonateC4()
	if not SERVER then return end
	local ply = self:GetOwner()
	if IsValid(ply) and ply:IsPlayer() then
		for k, v in pairs(self:GetBombs()) do
			timer.Simple(.05 * k, function()
				if IsValid(v) then
					v:Explode()
				end
			end)
		end
	end	
end

function SWEP:PreSpawnProjectile(ent)
	local isnpc = self:GetOwner():IsNPC()
	
	if not isnpc then
	ent.Cooked = math.huge
	else
	ent.Cooked = CurTime() + 1.5
	end
end

function SWEP:PostSpawnProjectile(ent)
	local angvel = Vector(0,math.random(-2000,-1500),math.random(-1500,-2000)) //The positive z coordinate emulates the spin from a right-handed overhand throw
	angvel:Rotate(-1*ent:EyeAngles())
	angvel:Rotate(Angle(0,self.Owner:EyeAngles().y,0))
	
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddAngleVelocity(angvel)
	end

	local bombs = self:GetBombs()
	if #bombs > 5 then
		for i = 1, #bombs - 5 do
			bombs[1]:Remove()
		end
	end
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 or not self:OwnerIsValid() or not self:CanFire() then return end

	local _, tanim = self:ChoosePullAnim()

	self:ScheduleStatus(TFA.Enum.STATUS_GRENADE_PULL, self:GetActivityLength(tanim))
	self:SetNW2Bool("Underhanded", false)
	print("THROW")
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	
	if self:GetStatus() ~= TFA.Enum.STATUS_C4_DETONATE then
		self:SendViewModelAnim(ACT_VM_PRIMARYATTACK)
		self:ScheduleStatus(TFA.Enum.STATUS_C4_DETONATE, self:GetActivityLength())
		self:SetNextPrimaryFire(self:GetStatusEnd())
		return
	end
end

function SWEP:Reload()
	if self:Clip1() <= 0 then
		if self:Ammo1() > 0 then
			self:TakePrimaryAmmo(1, true)
			self:SetClip1(1)
		end
	end
end

function SWEP:CanFire() -- what
	if not self:CanPrimaryAttack() then return false end
	return true
end

function SWEP:ChooseIdleAnim(...)
	if self:GetStatus() == TFA.Enum.STATUS_GRENADE_READY then return end
	return BaseClass.ChooseIdleAnim(self, ...)
end

function SWEP:CycleSafety()
end

function SWEP:CanSecondaryAttack()
	local self2 = self:GetTable()
	local l_CT = CurTime
	
	stat = self:GetStatus()
	if not TFA.Enum.ReadyStatus[stat] and stat ~= TFA.Enum.STATUS_SHOOTING then
		return false
	end

	if self:GetSprintProgress() >= 0.1 and not self:GetStatL("AllowSprintAttack", false) then
		return false
	end

	if self2.GetStatL(self, "Primary.FiresUnderwater") == false and self:GetOwner():WaterLevel() >= 3 then
		self:SetNextPrimaryFire(l_CT() + 0.5)
		self:EmitSound(self:GetStatL("Primary.Sound_Blocked"))
		return false
	end

	if l_CT() < self:GetNextPrimaryFire() then return false end
	return true
end

SWEP.CrosshairConeRecoilOverride = .05

TFA.FillMissingMetaValues(SWEP)

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

if SERVER then
	function HORDE:MakeExplosionEffect(pos, ent)
		if CreateGrenadeExplosion then
			CreateGrenadeExplosion(pos)
			if ent then HORDE:EmitExplosionSound(ent, 125) end
		else
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)
		end
	end
	
	function HORDE:EmitExplosionSound(ent, soundlevel, pitch) 
		ent:EmitSound("weapons/explode" .. math.random(3, 5) .. ".wav", soundlevel, pitch)
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/tfa_cso/w_chain_grenade.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	--self.Entity:PhysicsInitSphere( ( self:OBBMaxs() - self:OBBMins() ):Length()/4, "metal" )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(6.5)
		phys:SetDamping(0.1,5)
	end
	
	self:SetFriction(3)
	
	self.timeleft = CurTime() + 1.5 -- HOW LONG BEFORE EXPLOSION
	self:Think()
	self.NextExplode = CurTime() + self.MidDelay
end

ENT.Delay = 3
ENT.MidDelay = 0.35
ENT.MaxExplodes = 2

function ENT:Think()
if self.timeleft < CurTime() then
  if CurTime()>self.NextExplode then
    self:Explosion()
    self.NextExplode = CurTime() + self.MidDelay
    self.exp = ( self.exp or 0 ) + 1
    if self.exp > self.MaxExplodes then
      self:Remove()
    end
  end
end
end

function ENT:Explosion()

	if not IsValid(self.Owner) then
		self.Entity:Remove()
		return
	end
	
	HORDE:MakeExplosionEffect(self.Entity:GetPos())

	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), 250, 160)
	--																radius, damage
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "2000")	// Power of the shake
		shake:SetKeyValue("radius", "1250")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()

	self.Entity:EmitSound("weapons/explode" .. math.random(3, 5) .. ".wav", self.Pos, 100, 100 )
end

/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
end


/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use( activator, caller, type, value )
end


/*---------------------------------------------------------
StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
end


/*---------------------------------------------------------
EndTouch
---------------------------------------------------------*/
function ENT:EndTouch( entity )
end


/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
end
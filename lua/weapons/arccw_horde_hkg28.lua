SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_g28.vtf")
    killicon.Add("arccw_horde_hkg28", "arccw/weaponicons/arccw_horde_g28", Color(0, 0, 0, 255))
end
SWEP.PrintName = "HK G28"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel				= "models/weapons/v_g28_cas.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_g28_cas.mdl"
--SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(
    5, 1, -2
    ),--Vector(-2.5, 4.25, -5.65),
    ang        =    Angle(0, 0, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   1.0
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 105
SWEP.DamageMin = 90 -- damage done at maximum range
SWEP.RangeMin = 120
SWEP.Range = 180 -- in METRES

SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 650 -- projectile or phys bullet muzzle velocity
-- IN M/S

--[[SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(34, 88, 250)
SWEP.TracerWidth = 3
SWEP.Tracer = "cel_muzzleflash"]]
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 20 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 10

SWEP.Recoil = .6
SWEP.RecoilSide = .4
SWEP.RecoilRise = .5
SWEP.VisualRecoilMult = 0.14

SWEP.Delay = 60 / 540 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {"weapon_ar2"}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 1.5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 200 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses
SWEP.MagID = "g28" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

--SWEP.FirstShootSound = "ArcCW_BO1.M14_Fire"
SWEP.ShootSound			= Sound("weapons/tfa_ins2_g28/g28-1.wav")
SWEP.ShootSoundSilenced			= Sound("weapons/tfa_ins2_g28/g28_sil-1.wav")

SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5

--[[SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1]]
--SWEP.CamAttachment = 5

SWEP.SpeedMult = 0.85
SWEP.SightedSpeedMult = 0.5
SWEP.Sightt = 0.35

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.905, 0, 1.462),
    Ang = Vector(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

--[[SWEP.ActivePos = Vector(0, -1, -1)
SWEP.ActiveAng = Angle(0, 0, 0)]]

SWEP.SprintPos = Vector(4.8, 6, 0)
SWEP.SprintAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(15, 4, -2)
SWEP.CustomizeAng = Angle(15, 40, 20)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 22
SWEP.AttachmentElements = { 
	["mount"] = {
        VMElements = {
            {
                Model = "models/weapons/upgrades/v_g28_default_sights.mdl",
                Bone = "A_Optic",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(-2.95, 2.3, -13),
                    ang = Angle(90, 0, 90),
                }
            }
        },
    },
}


--SWEP.ExtraSightDist = 5
SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "A_Optic", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -.3, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 90),
            wpos = Vector(10, .8, -7.35),
            wang = Angle(0, 0, 0)
        },
		DefaultEles = {"mount"},
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "A_Foregrip",
        Offset = {
            vpos = Vector(0, -8, 0),
            vang = Angle(0, 90, 0),
            wpos = Vector(25, 1, -3.25),
            wang = Angle(0, 0, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "a_suppressor",
        Offset = {
            vpos = Vector(0, -5.3, 0),
            vang = Angle(0, 90, 0),
            wpos = Vector(32, 0.782, -5.5),
            wang = Angle(0, 0,  0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "A_Foregrip",
        VMScale = Vector(1.2, 1, 1),
        WMScale = Vector(1.2, 1, 1),
        Offset = {
            vpos = Vector(0, 2, -.1), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 90, 0),
            wpos = Vector(9.5, 1.15, -4.2),
            wang = Angle(180, -180, 0),
        },
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "Standard Stock"
    },
    {
        PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG"
    },
    {
        PrintName = "Ammo Type",
        Slot = "ammo_bullet"
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "A_Optic", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-1, -2.5, -1), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 90),
            wpos = Vector(8, 2.3, -3.5),
            wang = Angle(-2.829, -4.902, 180)
        },
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "base_ready",
	},
    ["draw"] = {
        Source = "base_draw",
    },
    ["reload"] = {
        Source = "base_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = 1, LHIKEaseOut = .5,
    },
    ["reload_empty"] = {
        Source = "base_reloadempty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = .6, LHIKEaseIn = .5,
        LHIKOut = 1, LHIKEaseOut = .5,
    },
    ["holster"] = {
		Source = "base_holster",
        SoundTable = {
           {t = 0, s = Sound("TFA_INS2.Holster")},
    	}
    },
}

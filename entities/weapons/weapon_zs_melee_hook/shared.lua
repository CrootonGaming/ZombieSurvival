-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

SWEP.Author = "Duby"
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_plank.mdl")

if CLIENT then
	SWEP.ShowViewModel = false 
	--SWEP.ShowWorldModel = false

SWEP.VElements = {

	["1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -5.715), angle = Angle(1.169, 87.662, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }



}

	
SWEP.WElements = {
	--["pipe1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 3.635, -4.676), angle = Angle(-12.858, 59.61, -8.183), size = Vector(0.432, 0.432, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["pipe1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl",  bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.941, 2.631, -6.678), angle = Angle(90, 180, -53.116), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["pipe2"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

	killicon.AddFont( "weapon_zs_melee_crowbar", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )
	

end


-- Model paths

--SWEP.HoldType = "melee2"
SWEP.DeploySpeed = 0.6
-- Name and fov
SWEP.PrintName = "Meat Hook"
SWEP.ViewModelFOV = 65

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 3

-- Damage, distance, delay
SWEP.Primary.Delay = 0.85
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 50
SWEP.MeleeRange = 45
SWEP.MeleeSize = 1.45
SWEP.WalkSpeed = 190
SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.0

SWEP.SwingTime = 0.55
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_Crowbar.Melee_Hit")
end
-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"
SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.PrintName = "Ghast"


if CLIENT then
	SWEP.ViewModelFOV = 80
	SWEP.ViewModelFlip = false
	SWEP.FakeArms = true	
end

SWEP.Primary.Duration = 1.3
SWEP.Primary.Delay = 0.6
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 22
SWEP.DisguiseChoice = 1
SWEP.EmitWraithSound = 0
SWEP.Attacking = 0

SWEP.Screams = {
	Sound("npc/stalker/stalker_alert1b.wav"),
	Sound("npc/stalker/stalker_alert2b.wav"),
	Sound("npc/stalker/stalker_alert3b.wav")
}

-- Human scream sounds
SWEP.HumanScreams = {
	Sound("ambient/voices/m_scream1.wav"),
	Sound("ambient/voices/f_scream1.wav")
}

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("npc/stalker/breathing3.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[4].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[4].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.Screams) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.HumanScreams) do
		util.PrecacheSound(snd)
	end
	
	for i=1, 4 do
		util.PrecacheSound("npc/stalker/stalker_scream"..i..".wav")
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	local model = "models/player/soldier_stripped.mdl"
	self.Owner:SetModel(model)

	if SERVER then
		self.ScarySound = CreateSound(self.Owner, Sound("ambient/voices/crying_loop1.wav"))
	end
end

function SWEP:StartPrimaryAttack()		
	-- Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	self.Attacking = CurTime() + 1.5
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if self:IsDisguised() then
		self:EmitSound(Sound("npc/antlion/distract1.wav"), 80, math.random(82, 92))
		self:SetDisguiseChoice(math.random(1,5)	)		
	else
		self:EmitSound(Sound("npc/antlion/distract1.wav"), 80, math.random(72, 80))
	end
	
	--local stopPlayer = true

	--if not self:IsDisguised() then
	--	self.Primary.Speed = 120
	--end
	 
	--if SERVER then
	--	if stopPlayer then
	--		self.Owner:SetLocalVelocity(Vector(0, 0, 0))
	--	end
	--end
end

function SWEP:Move(mv)
	if self and self.Owner and not self:IsDisguised() then
		mv:SetMaxSpeed(145)		
		return true
	elseif self and self.Owner and self.Attacking > CurTime() then
		mv:SetMaxSpeed(50)		
		return true		
	end
end

function SWEP:SetDisguise(bl)
	self:SetDTBool(0,bl)
	self:DrawShadow(bl)
end

function SWEP:IsDisguised()
	return self:GetDTBool(0)
end

function SWEP:SetDisguiseChoice(choice)
	self:SetDTInt(1, choice)
end

function SWEP:GetDisguiseChoice()
	return self:GetDTInt(1)
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 2)
	-- if self.Disguised then return end
	if self:IsDisguised() then
		self:EmitSound(Sound("npc/fast_zombie/idle"..math.random(1,3)..".wav"), 80)	
		self:SetDisguise(false)
		
		if CLIENT then
			self:RemoveArms()
			self.ShowViewModel = true
		end
		
		local model = Model("models/player/soldier_stripped.mdl" )
		self.Owner:SetModel(model)
		self.Owner:SetMaximumHealth(160)
		self.Owner:SetHealth(math.Clamp(self.Owner:Health(),1,self.Owner:GetMaximumHealth()))		
		return
	end
	
	self:SetDisguise(true)
	
	--Pick random human model
	if SERVER then	
				local model = "models/player/kleiner.mdl"
		self:SetDisguiseChoice(math.random(1,5)	)	
		self.Owner:SetPlayerColor(Vector(math.random(0.01,1),math.random(0.01,1),math.random(0.01,1)))
		local survivors = team.GetPlayers(TEAM_HUMAN)
		if #survivors > 0 then
			model = table.Random(survivors):GetModel()
		end
		self.Owner:SetMaximumHealth(100)
		self.Owner:SetHealth(math.Clamp(self.Owner:Health(),1,self.Owner:GetMaximumHealth()))
		self.Owner:SetModel(model)
		self:EmitSound(Sound("npc/fast_zombie/idle"..math.random(1,3)..".wav"), 80)	
	end

	if CLIENT then
		self.ShowViewModel = false
		self:MakeArms()
	end	
end

-- Play teleport fail sound
--[[function SWEP:TeleportFail()
	if SERVER then
		if ( self.TeleportWarnTime or 0 ) <= CurTime() then
			-- self.Owner:EmitSound( "npc/zombie_poison/pz_idle4.wav", 70, math.random( 92, 105 ) ) --Moo
			self.Owner:EmitSound( "npc/stalker/stalker_ambient01.wav", 70, 100 ) 
			self.TeleportWarnTime = CurTime() + 0.97
		end
	end
end]]


function SWEP:OnRemove()
	if SERVER then
		self.ScarySound:Stop()
	end

	self.BaseClass.OnRemove(self)
end 

-- Main think
function SWEP:Think()
	self.BaseClass.Think(self)

	if SERVER then
		if self.ScarySound then
			self.ScarySound:PlayEx(0.2, 95 + math.sin(RealTime())*8) 
		end 
	end
end

-- Precache sounds
util.PrecacheSound("npc/antlion/distract1.wav")
util.PrecacheSound("ambient/machines/slicer1.wav")
util.PrecacheSound("ambient/machines/slicer2.wav")
util.PrecacheSound("ambient/machines/slicer3.wav")
util.PrecacheSound("ambient/machines/slicer4.wav")
util.PrecacheSound("npc/zombie/claw_miss1.wav")
util.PrecacheSound("npc/zombie/claw_miss2.wav")



  

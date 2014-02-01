if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.PrintName			= "A-10A Thunderbolt"
ENT.Author				= "SentryGunMan"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model	    = "models/sentry/a10.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel	= "models/sentry/a10_prop.mdl"
ENT.RotorModel2	= "models/sentry/a10_prop.mdl"

ENT.rotorPos	= Vector(-149.5,57.4,129)
ENT.rotorPos2	= Vector(-149.5,-57.4,129)

ENT.TopRotorDir	= 1

ENT.EngineForce	= 535
ENT.Weight	    = 3347
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.02
ENT.SmokePos	= Vector(-149.5,57.4,129)
ENT.FirePos	    = Vector(-149.5,57.4,129)

if CLIENT then
	ENT.thirdPerson = {
		distance = 550
	}
end

ENT.Agility = {
	Thrust = 15
}

ENT.Wheels={
	{
		mdl="models/sentry/a10_fw.mdl",
		pos=Vector(139.5,-8,10),
		friction=0,
		mass=500,
	},
	{
		mdl="models/sentry/a10_bw.mdl",
		pos=Vector(-93,110.5,15),
		friction=0,
		mass=550,
	},
	{
		mdl="models/sentry/a10_bw.mdl",
		pos=Vector(-93,-108,15),
		friction=0,
		mass=550,
	},
}

ENT.Seats = {
	{
		pos=Vector(126.5,1,100),
		exit=Vector(126.5,70,20),
		weapons={"GAU-8 Avenger", "Hydra 70"}
	},
}

ENT.Weapons = {
	["GAU-8 Avenger"] = {
		class = "wac_pod_gatling",
		info = {
			Pods = {
				Vector(267.5,4,69),
				Vector(267.5,4,69)
			},
			Ammo = 1175,
			FireRate = 4000,
			Sounds = {
				shoot = "WAC/a10/gun.wav",
				stop = "WAC/a10/gun_stop.wav"
			}
		}
	},
	["Hydra 70"] = {
		class = "wac_pod_hydra",
		info = {
			Sequential = true,
			Pods = {
				Vector(7.5, -245.5, 54),
				Vector(7.5, 248, 54)
			},
		},
	},
}

ENT.Sounds={
	Start="WAC/A10/Start.wav",
	Blades="WAC/A10/external.wav",
	Engine="WAC/A10/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3"
}

// heatwave
if CLIENT then
	local cureffect=0
	function ENT:Think()
		self:base("wac_pl_base").Think(self)
		local throttle = self:GetNWFloat("up", 0)
		local active = self:GetNWBool("active", false)
		local ent=LocalPlayer():GetVehicle():GetNWEntity("wac_aircraft")
		if ent==self and active and throttle > 0.2 and CurTime()>cureffect then
			cureffect=CurTime()+0.02
			local ed=EffectData()
			ed:SetEntity(self)
			ed:SetOrigin(Vector(-260,57.4,129)) // offset
			ed:SetMagnitude(throttle)
			ed:SetRadius(25)
			util.Effect("wac_heatwave", ed)
			
			local ed=EffectData()
			ed:SetEntity(self)
			ed:SetOrigin(Vector(-260,-57.4,129)) // offset
			ed:SetMagnitude(throttle)
			ed:SetRadius(25)
			util.Effect("wac_heatwave", ed)
		end
	end
end

function ENT:DrawWeaponSelection() end


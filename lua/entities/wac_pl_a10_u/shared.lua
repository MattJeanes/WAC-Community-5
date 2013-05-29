if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base_u"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategoryU
ENT.PrintName			= "Fairchild Republic A-10"
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

function ENT:DrawWeaponSelection() end


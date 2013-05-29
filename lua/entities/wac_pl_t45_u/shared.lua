if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base_u"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategoryU
ENT.PrintName			= "Boeing T-45C Goshawk"
ENT.Author				= "Chippy"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model	    = "models/chippy/t45/body.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel	= "models/props_junk/PopCan01a.mdl"

ENT.TopRotorPos	= Vector(0,0,10.25)
ENT.TopRotorDir	= 1

ENT.EngineForce	= 680
ENT.Weight	    = 3720
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.02
ENT.SmokePos	= Vector(-180,0,-1.25)
ENT.FirePos	    = Vector(-180,0,-1.25)

if CLIENT then
	ENT.thirdPerson = {
		distance = 320
	}
end

ENT.Wheels={
	{
		mdl="models/chippy/t45/fwheel.mdl",
		pos=Vector(156,0,-55),
		friction=10,
		mass=350,
	},
	{
		mdl="models/chippy/t45/bwheel.mdl",
		pos=Vector(-15,-78,-50),
		friction=20,
		mass=230,
	},
	{
		mdl="models/chippy/t45/bwheel.mdl",
		pos=Vector(-15,78,-50),
		friction=20,
		mass=230,
	},
}

ENT.Seats = {
	{
		pos=Vector(130.5,0,-12.5),
		exit=Vector(-62.,60,85),
	},
	{
		pos=Vector(75.5,0,3.5),
		exit=Vector(-62.,60,85),
	}
}

ENT.Sounds={
	Start="WAC/T45/start.wav",
	Blades="WAC/T45/external.wav",
	Engine="WAC/T45/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="WAC/T45/warning.wav",
	LowHealth="WAC/T45/engfail.wav",
	CrashAlarm="WAC/T45/engfail.wav"
}

function ENT:DrawWeaponSelection() end
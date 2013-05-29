if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategory
ENT.PrintName			= "P-51D Mustang"
ENT.Author				= "SentryGunMan"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model	    = "models/sentry/p51.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel	= "models/sentry/p51_prop.mdl"

ENT.rotorPos	= Vector(159.25,0,81.22)
ENT.TopRotorDir	= 1

ENT.EngineForce	= 335
ENT.Weight	    = 3347
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.01
ENT.SmokePos	= Vector(110,0,72.25)
ENT.FirePos	    = Vector(110,0,72.25)

if CLIENT then
	ENT.thirdPerson = {
		distance = 550
	}
end

ENT.Wheels={
	{
		mdl="models/sentry/p51_bw.mdl",
		pos=Vector(-132.5,0,46.5),
		friction=0,
		mass=500,
	},
	{
		mdl="models/sentry/p51_fw.mdl",
		pos=Vector(63.5,68,14.5),
		friction=0,
		mass=550,
	},
	{
		mdl="models/sentry/p51_fw.mdl",
		pos=Vector(63.5,-68,14.5),
		friction=0,
		mass=550,
	},
}

ENT.Seats = {
	{
		pos=Vector(10,0,74.5),
		exit=Vector(10,60,85),
    }
}

ENT.Sounds={
	Start="WAC/P51/Start.wav",
	Blades="WAC/P51/external.wav",
	Engine="WAC/P51/internal.wav",
	MissileAlert="",
	MissileShoot="",
	MinorAlarm="",
	LowHealth="",
	CrashAlarm=""
}

function ENT:DrawPilotHud() end
function ENT:DrawWeaponSelection() end
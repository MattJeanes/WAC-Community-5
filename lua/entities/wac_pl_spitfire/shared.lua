if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategory
ENT.PrintName			= "Supermarine Spitfire V"
ENT.Author				= "SentryGunMan"
ENT.AutomaticFrameAdvance = true // needed for gear anims

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model	    = "models/sentry/spitfire.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel	= "models/sentry/spitfire_prop.mdl"

ENT.rotorPos	= Vector(161,-0.25,75.5)
ENT.TopRotorDir	= 1

ENT.EngineForce	= 365
ENT.Weight	    = 3000
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.02
ENT.SmokePos	= Vector(110,0,72.25)
ENT.FirePos	    = Vector(110,0,72.25)

if CLIENT then
	ENT.thirdPerson = {
		distance = 550
	}
end

ENT.Agility = {
	Thrust = 10
}

ENT.Wheels={
	{
		mdl="models/sentry/spitfire_bw.mdl",
		pos=Vector(-150.5,0,58.75),
		friction=50,
		mass=1000,
	},
	{
		mdl="models/sentry/spitfire_fw_l.mdl",
		pos=Vector(80.5,34,10),
		friction=1,
		mass=550,
	},
	{
		mdl="models/sentry/spitfire_fw_r.mdl",
		pos=Vector(80.5,-34,10),
		friction=1,
		mass=550,
	},
}

ENT.Seats = {
	{
		pos=Vector(20,-0.25,60.5),
		exit=Vector(10,59,85),
	}
}

ENT.Sounds={
	Start="WAC/Spitfire/Start.wav",
	Blades="WAC/Spitfire/external.wav",
	Engine="WAC/Spitfire/internal.wav",
	MissileAlert="",
	MissileShoot="",
	MinorAlarm="",
	LowHealth="",
	CrashAlarm=""
}


function ENT:DrawPilotHud() end
function ENT:DrawWeaponSelection() end

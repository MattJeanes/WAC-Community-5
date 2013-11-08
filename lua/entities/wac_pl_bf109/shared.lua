if not wac then return end
if SERVER then AddCSLuaFile() end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategory
ENT.PrintName			= "Messerschmitt BF-109E"
ENT.Author				= "SentryGunMan"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model	    = "models/sentry/bf109.mdl"
ENT.RotorPhModel	= "models/props_junk/sawblade001a.mdl"
ENT.RotorModel	= "models/sentry/bf109_prop.mdl"
ENT.rotorPos	= Vector(169.2,0,88.1)
ENT.TopRotorDir	= 1

ENT.EngineForce	= 435
ENT.Weight	    = 3347
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul		= 0.02
ENT.SmokePos	= Vector(169,0,88.1)
ENT.FirePos	    = Vector(169,0,88.1)

if CLIENT then
	ENT.thirdPerson = {
		distance = 650
	}
end

ENT.Agility = {
	Thrust = 10
}

ENT.Wheels={
	{
		mdl="models/sentry/bf109_bw.mdl",
		pos=Vector(-238.5,0,86),
		friction=0,
		mass=500,
	},
	{
		mdl="models/sentry/bf109_fw.mdl",
		pos=Vector(57.5,49.5,16.5),
		friction=0,
		mass=550,
	},
	{
		mdl="models/sentry/bf109_fw.mdl",
		pos=Vector(57.5,-49.5,16.5),
		friction=0,
		mass=550,
	},
}

ENT.Seats = {
	{
		pos=Vector(3.5,0,90),
		exit=Vector(3.5,60,100),
		//weapons={"MG17", "Bomb"}
		weapons={"MG17"}
    }
}					

ENT.Weapons = {
	["MG17"] = {
		class = "wac_pod_gatling",
		info = {
			Pods = {
				Vector(90.5,-116.5,80.5),
				Vector(90.5,116.5,80.5)
			},
			FireRate = 500,
			Sequential = true,
			Sounds = {
				shoot = "WAC/bf109/gun.wav",
				stop = "WAC/bf109/gun_stop.wav"
			}
		}
	},
	/*
	["Bomb"] = {
		class = "wac_pod_bomb",
		info = {
			Pods = {
				Vector(40,0,40),
				Vector(40,30,40),
				Vector(40,60,40),
				Vector(40,90,40),
				Vector(40,120,40),
				Vector(40,150,40),
				Vector(40,-30,40),
				Vector(40,-60,40),
				Vector(40,-90,40),
				Vector(40,-120,40),
				Vector(40,-150,40),
			},
			model="models/props_phx/ww2bomb.mdl",
			reload=2,
			mode=false,
		}
	}
	*/
}

ENT.Sounds={
	Start="WAC/Bf109/Start.wav",
	Blades="WAC/BF109/external.wav",
	Engine="WAC/BF109/internal.wav",
	MissileAlert="",
	MissileShoot="",
	MinorAlarm="",
	LowHealth="",
	CrashAlarm=""
}


//function ENT:DrawPilotHud() end
//function ENT:DrawWeaponSelection() end
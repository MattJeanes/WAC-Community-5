if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategory
ENT.PrintName			= "Mitsubishi A6M2 Zero"
ENT.Author				= "SentryGunMan"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model            = "models/sentry/a6m2.mdl"
ENT.RotorPhModel        = "models/props_junk/sawblade001a.mdl"
ENT.RotorModel        = "models/sentry/a6m2_prop.mdl"

ENT.TopRotorPos        = Vector(101,0,74)
ENT.TopRotorDir        = 1

ENT.EngineForce        = 465
ENT.Weight            = 2410
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.015
ENT.SmokePos        = Vector(101,0,74)
ENT.FirePos            = Vector(101,0,74)

if CLIENT then
	ENT.thirdPerson = {
		distance = 550
	}
end

ENT.WheelInfo={
	{
		mdl="models/sentry/a6m2_bw.mdl",
		pos=Vector(-205.5,0,59.75),
		friction=10,
		mass=600,
	},
	{
		mdl="models/sentry/a6m2_fw.mdl",
		pos=Vector(42,68,12),
		friction=10,
		mass=550,
	},
	{
		mdl="models/sentry/a6m2_fw.mdl",
		pos=Vector(42,-68,12),
		friction=10,
		mass=550,
	},
}

function ENT:AddSeatTable()
    return{
        [1]={
            Pos=Vector(2.5,0,70.23),
            ExitPos=Vector(10,59,85),
            NoHud=true,
			wep={[1]=wac.aircraft.getWeapon("M134",{
				Name="Type 97 and Type 99-1",
				Ammo=1120,
				MaxAmmo=1120,
				NextShoot=1,
				LastShot=0,
				Gun=1,
				ShootDelay=0.06,
				func=function(self, t, p)
					if t.NextShoot <= CurTime() then
						if t.Ammo>0 then
							local Positions = { Vector(70,8.9,96), Vector(70,-8.9,96), Vector(67,-86.5,69), Vector(67,86.5,69) } 
							local ShootPos = table.Random( Positions )

							if !t.Shooting then
								t.Shooting=true
								t.SStop:Stop()
								t.SShoot:Play()
								t.SStop2:Stop()
								t.SShoot2:Play()
							end

							local bullet={}
							bullet.Num 		= 1
							bullet.Src 		= self:LocalToWorld(ShootPos+Vector(self:GetVelocity():Length()*0.6,0,0))
							bullet.Dir 		= self:GetForward()
							bullet.Spread 	= Vector(0.023,0.023,0)
							bullet.Tracer		= 0
							bullet.Force		= 80
							bullet.Damage	= 200
							bullet.Attacker 	= p
							local effectdata=EffectData()
							effectdata:SetOrigin(self:LocalToWorld(ShootPos))
							effectdata:SetAngles(self:GetAngles())
							effectdata:SetScale(1.5)
							util.Effect("MuzzleEffect", effectdata)
							self.Entity:FireBullets(bullet)
							t.Gun=(t.Gun==1 and 2 or 1)
							t.Ammo=t.Ammo-1
							t.LastShot=CurTime()
							t.NextShoot=t.LastShot+t.ShootDelay
							local ph=self:GetPhysicsObject()
							if ph:IsValid() then
								ph:AddAngleVelocity(Vector(0,0,t.Gun==1 and 3 or -3))
							end
						end
						if t.Ammo<=0 then
							t.StopSounds(self,t,p)
							t.Ammo=t.MaxAmmo
							t.NextShoot=CurTime()+20
						end
					end
				end,
				StopSounds=function(self,t,p)
					if t.Shooting then
						t.SShoot:Stop()
						t.SStop:Play()
						t.SShoot2:Stop()
						t.SStop2:Play()
						t.Shooting=false
					end
				end,
				Init=function(self,t)
					t.SShoot=CreateSound(self,"WAC/A6M2/gun.wav")
					t.SStop=CreateSound(self,"WAC/A6M2/gun_stop.wav")
					t.SShoot2=CreateSound(self,"WAC/A6M2/gun2.wav")
					t.SStop2=CreateSound(self,"WAC/A6M2/gun2_stop.wav")
				end,
				Think=function(self,t,p)
					if t.NextShoot<=CurTime() then
						t.StopSounds(self,t,p)
					end
				end,
				DeSelect=function(self,t,p)
					t.StopSounds(self,t,p)
				end
				}),
			},
		},
	}
end
function ENT:AddSounds()
    self.Sound={
        Start=CreateSound(self.Entity,"WAC/A6M2/Start.wav"),
        Blades=CreateSound(self.Entity,"A6M2.External"),
        Engine=CreateSound(self.Entity,"A6M2.Internal"),
        MissileAlert=CreateSound(self.Entity,""),
        MissileShoot=CreateSound(self.Entity,""),
        MinorAlarm=CreateSound(self.Entity,""),
        LowHealth=CreateSound(self.Entity,""),
        CrashAlarm=CreateSound(self.Entity,""),
    }
end


function ENT:DrawPilotHud() end
function ENT:DrawWeaponSelection() end

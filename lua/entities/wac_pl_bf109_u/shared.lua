if not wac then return end
if SERVER then AddCSLuaFile() end
ENT.Base 				= "wac_pl_base_u"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategoryU
ENT.PrintName			= "Messerschmitt BF-109E"
ENT.Author				= "SentryGunMan"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model            = "models/sentry/bf109.mdl"
ENT.RotorPhModel        = "models/props_junk/sawblade001a.mdl"
ENT.RotorModel        = "models/sentry/bf109_prop.mdl"
ENT.TopRotorPos        = Vector(169.2,0,88.1)
ENT.TopRotorDir        = 1

ENT.EngineForce        = 435
ENT.Weight            = 3347
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul		= 0.02
ENT.SmokePos        = Vector(169,0,88.1)
ENT.FirePos            = Vector(169,0,88.1)

if CLIENT then
	ENT.thirdPerson = {
		distance = 650
	}
end

ENT.WheelInfo={
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


function ENT:AddSeatTable()
    return{
        [1]={
            Pos=Vector(3.5,0,90),
            ExitPos=Vector(3.5,60,100),
            NoHud=true,
			wep={[1]=wac.aircraft.getWeapon("M134",{
				Name="MG17",
				Ammo=1500,
				MaxAmmo=1500,
				NextShoot=1,
				LastShot=0,
				Gun=1,
				ShootDelay=0.025,
				func=function(self, t, p)
					if t.NextShoot <= CurTime() then
						if t.Ammo>0 then
							if !t.Shooting then
								t.Shooting=true
								t.SStop:Stop()
								t.SShoot:Play()
							end
							local Positions = { Vector(110.5,6,115.5), Vector(110.5,-6,115.5), Vector(110.5,-6,115.5),Vector(110.5,6,115.5), Vector(90.5,-116.5,80.5), Vector(90.5,116.5,80.5) } 
							local ShootPos = table.Random( Positions )

							local bullet={}
							bullet.Num 		= 1
							bullet.Src 		= self:LocalToWorld(ShootPos+Vector(self:GetVelocity():Length()*0.6,0,0))
							bullet.Dir 		= self:GetForward()
							bullet.Spread 	= Vector(0.023,0.023,0)
							bullet.Tracer		= 0
							bullet.Force		= 50
							bullet.Damage	= 180
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
							t.NextShoot=CurTime()+60
						end
					end
				end,
				StopSounds=function(self,t,p)
					if t.Shooting then
						t.SShoot:Stop()
						t.SStop:Play()
						t.Shooting=false
					end
				end,
				Init=function(self,t)
					t.SShoot=CreateSound(self,"WAC/Bf109/gun.wav")
					t.SStop=CreateSound(self,"WAC/Bf109/gun_stop.wav")
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
        Start=CreateSound(self.Entity,"WAC/Bf109/Start.wav"),
        Blades=CreateSound(self.Entity,"BF109.External"),
        Engine=CreateSound(self.Entity,"BF109.Internal"),
        MissileAlert=CreateSound(self.Entity,""),
        MissileShoot=CreateSound(self.Entity,""),
        MinorAlarm=CreateSound(self.Entity,""),
        LowHealth=CreateSound(self.Entity,""),
        CrashAlarm=CreateSound(self.Entity,""),
    }
end


function ENT:DrawPilotHud() end
function ENT:DrawWeaponSelection() end
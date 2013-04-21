if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base_u"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategoryU
ENT.PrintName			= "Supermarine Spitfire V"
ENT.Author				= "SentryGunMan"
ENT.AutomaticFrameAdvance = true // needed for gear anims

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model            = "models/sentry/spitfire.mdl"
ENT.RotorPhModel        = "models/props_junk/sawblade001a.mdl"
ENT.RotorModel        = "models/sentry/spitfire_prop.mdl"

ENT.TopRotorPos        = Vector(161,-0.25,75.5)
ENT.TopRotorDir        = 1

ENT.EngineForce        = 365
ENT.Weight            = 3000
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.02
ENT.SmokePos        = Vector(110,0,72.25)
ENT.FirePos            = Vector(110,0,72.25)

if CLIENT then
	ENT.thirdPerson = {
		distance = 550
	}
end

ENT.WheelInfo={
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

function ENT:AddSeatTable()
    return{
        [1]={
            Pos=Vector(20,-0.25,60.5),
            ExitPos=Vector(10,59,85),
            NoHud=true,
			wep={[1]=wac.aircraft.getWeapon("M134",{
					Name="Browning M2",
					Ammo=240,
					MaxAmmo=240,
					NextShoot=1,
					LastShot=0,
					Gun=1,
					ShootDelay=0.1,
					func=function(self, t, p)
						if t.NextShoot <= CurTime() then
							if t.Ammo>0 then
								local ShootPos
								if (t.Ammo % 2 == 0) then ShootPos = Vector(135.5,75,53.75) else ShootPos = Vector(135.5,-75,53.75) end
								if !t.Shooting then
									t.Shooting=true
									t.SStop:Stop()
									t.SShoot:Play()
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
						t.Shooting=false
					end
				end,
				Init=function(self,t)
					t.SShoot=CreateSound(self,"WAC/Spitfire/gun.wav")
					t.SStop=CreateSound(self,"WAC/Spitfire/gun_stop.wav")
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
        Start=CreateSound(self.Entity,"WAC/Spitfire/Start.wav"),
        Blades=CreateSound(self.Entity,"Spitfire.External"),
        Engine=CreateSound(self.Entity,"Spitfire.Internal"),
        MissileAlert=CreateSound(self.Entity,""),
        MissileShoot=CreateSound(self.Entity,""),
        MinorAlarm=CreateSound(self.Entity,""),
        LowHealth=CreateSound(self.Entity,""),
        CrashAlarm=CreateSound(self.Entity,""),
    }
end


function ENT:DrawPilotHud() end
function ENT:DrawWeaponSelection() end

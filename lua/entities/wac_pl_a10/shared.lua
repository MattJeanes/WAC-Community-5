if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategory
ENT.PrintName			= "Fairchild Republic A-10"
ENT.Author				= "SentryGunMan"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model            = "models/sentry/a10.mdl"
ENT.RotorPhModel        = "models/props_junk/sawblade001a.mdl"
ENT.RotorModel        = "models/sentry/a10_prop.mdl"

ENT.TopRotorPos        = Vector(-149.5,57.4,129)
ENT.TopRotorDir        = 1

ENT.EngineForce        = 535
ENT.Weight            = 3347
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.02
ENT.SmokePos        = Vector(-149.5,57.4,129)
ENT.FirePos            = Vector(-149.5,57.4,129)

ENT.OtherRotorPos = Vector(-149.5,-57.4,129)

if CLIENT then
	ENT.thirdPerson = {
		distance = 550
	}
end

ENT.WheelInfo={
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

function ENT:AddSeatTable()
    return {
        [1]={
            Pos=Vector(126.5,1,100),
            ExitPos=Vector(126.5,70,20),
            NoHud=true,
			wep={[1]=wac.aircraft.getWeapon("M134",{
				Name="GAU-8 Avenger",
				Ammo=1200,
				MaxAmmo=1200,
				NextShoot=1,
				LastShot=0,
				Gun=1,
				ShootDelay=0.015,
				ShootPos=Vector(267.5,4,69),
				func=function(self, t, p)
					if t.NextShoot <= CurTime() then
						if t.Ammo>0 then

							if !t.Shooting then
								t.Shooting=true
								t.SStop:Stop()
								t.SShoot:Play()
							end
							local bullet={}
							bullet.Num 		= 1
							bullet.Src 		= self:LocalToWorld(Vector(267.5,4,69)+Vector(self:GetVelocity():Length()*0.6,0,0))
							bullet.Dir 		= self:GetForward()
							bullet.Spread 	= Vector(0.053,0.053,0)
							bullet.Tracer		= 0
							bullet.Force		= 90
							bullet.Damage	= 280
							bullet.Attacker 	= p
							local effectdata=EffectData()
							effectdata:SetOrigin(self:LocalToWorld(Vector(267.5,4,69)))
							effectdata:SetAngles(self:GetAngles())
							effectdata:SetScale(2.5)
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
					t.SShoot=CreateSound(self,"WAC/A10/gun.wav")
					t.SStop=CreateSound(self,"WAC/A10/gun_stop.wav")
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
			[2]=wac.aircraft.getWeapon("Hydra 70",{
				Name="Hydra 70",
				Ammo=14,
				MaxAmmo=14,
				ShootPos={
					[1]=Vector( 7.5,-245.5,54),
					[2]=Vector( 7.5,248,54),
				}
			}),	
		},
	},
	}
end
function ENT:AddSounds()
    self.Sound={
        Start=CreateSound(self.Entity,"WAC/A10/Start.wav"),
        Blades=CreateSound(self.Entity,"A10.External"),
        Engine=CreateSound(self.Entity,"A10.Internal"),
		MissileAlert=CreateSound(self.Entity,"HelicopterVehicle/MissileNearby.mp3"),
		MissileShoot=CreateSound(self.Entity,"HelicopterVehicle/MissileShoot.mp3"),
		MinorAlarm=CreateSound(self.Entity,"HelicopterVehicle/MinorAlarm.mp3"),
		LowHealth=CreateSound(self.Entity,"HelicopterVehicle/LowHealth.mp3"),
		CrashAlarm=CreateSound(self.Entity,"HelicopterVehicle/CrashAlarm.mp3"),
    }
end

function ENT:DrawWeaponSelection() end

local function DrawLine(v1,v2)
	surface.DrawLine(v1.y,v1.z,v2.y,v2.z)
end

local mHorizon0=Material("WeltEnSTurm/WAC/Helicopter/hud_line_0")
local HudCol=Color(70,199,50,150)
local Black=Color(0,0,0,200)

mat={
	Material("WeltEnSTurm/WAC/Helicopter/hud_line_0"),
	Material("WeltEnSTurm/WAC/Helicopter/hud_line_high"),
	Material("WeltEnSTurm/WAC/Helicopter/hud_line_low"),
}

local function getspaces(n)
	if n<10 then
		n="      "..n
	elseif n<100 then
		n="    "..n
	elseif n<1000 then
		n="  "..n
	end
	return n
end

function ENT:DrawPilotHud()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetRight(), 90)
	ang:RotateAroundAxis(self:GetForward(), 90)
	
	local uptm = self.SmoothVal
	local upm = self.SmoothUp
	local spos=self.SeatsT[1].Pos

	cam.Start3D2D(self:LocalToWorld(Vector(30,3.75,37.75)+spos), ang,0.015)
		surface.SetDrawColor(HudCol)
		surface.DrawRect(234, 247, 10, 4)
		surface.DrawRect(254, 247, 10, 4)
		surface.DrawRect(247, 234, 4, 10)
		surface.DrawRect(247, 254, 4, 10)
		
		local a=self:GetAngles()
		a.y=0
		local up=a:Up()
		up.x=0
		up=up:GetNormal()
		
		local size=180
		local dist=10
		local step=12
		for p=-180,180,step do
			if a.p+p>-size/dist and a.p+p<size/dist then
				if p==0 then
					surface.SetMaterial(mat[1])
				elseif p>0 then
					surface.SetMaterial(mat[2])
				else
					surface.SetMaterial(mat[3])
				end
				surface.DrawTexturedRectRotated(250+up.y*(a.p+p)*dist,250-up.z*(a.p+p)*dist,300,300,a.r)
			end
		end
		
		surface.SetTextColor(HudCol)
		surface.SetFont("wac_heli_small")
		
		surface.SetTextPos(30, 410) 
		surface.DrawText("SPD  "..math.floor(self:GetVelocity():Length()*0.1) .."kn")
		surface.SetTextPos(30, 445)
		local tr=util.QuickTrace(pos+self:GetUp()*10,Vector(0,0,-999999),self.Entity)
		surface.DrawText("ALT  "..math.ceil((pos.z-tr.HitPos.z)*0.01905).."m")
		
		surface.SetTextPos(330,445)
		local n=self:GetNWInt("seat_1_1_ammo")
		if n==14 and self:GetNWFloat("seat_1_1_nextshot")>CurTime() then
			n=0
		end
		surface.DrawText(self.SeatsT[1].wep[1].Name..getspaces(n))
	cam.End3D2D()
end


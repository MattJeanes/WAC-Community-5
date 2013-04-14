if not wac then return end
if SERVER then AddCSLuaFile('shared.lua') end
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= wac.aircraft.spawnCategory
ENT.PrintName			= "Boeing T-45C Goshawk"
ENT.Author				= "Chippy"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model            = "models/chippy/t45/body.mdl"
ENT.RotorPhModel        = "models/props_junk/sawblade001a.mdl"
ENT.RotorModel        = "models/props_junk/PopCan01a.mdl"

ENT.TopRotorPos        = Vector(0,0,10.25)
ENT.TopRotorDir        = 1

ENT.EngineForce        = 680
ENT.Weight            = 3720
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0.02
ENT.SmokePos        = Vector(-180,0,-1.25)
ENT.FirePos            = Vector(-180,0,-1.25)

if CLIENT then
	ENT.thirdPerson = {
		distance = 320
	}
end

ENT.WheelInfo={
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

function ENT:AddSeatTable()
	return{
		[1]={
			Pos=Vector(130.5,0,-12.5),
			ExitPos=Vector(-62.,60,85),
			wep={
				[1]=wac.aircraft.getWeapon("No Weapon"),
			},
			NoHud=false,
		},
		[2]={
			Pos=Vector(75.5,0,3.5),
			ExitPos=Vector(-62.,60,85),
			NoHud=false,
			wep={wac.aircraft.getWeapon("No Weapon")},
		},
	}
end

function ENT:AddSounds()
    self.Sound={
        Start=CreateSound(self.Entity,"WAC/T45/start.wav"),
        Blades=CreateSound(self.Entity,"WAC/T45/external.wav"),
        Engine=CreateSound(self.Entity,"WAC/T45/internal.wav"),
        MissileAlert=CreateSound(self.Entity,"HelicopterVehicle/MissileNearby.mp3"),
		MissileShoot=CreateSound(self.Entity,"HelicopterVehicle/MissileShoot.mp3"),
        MinorAlarm=CreateSound(self.Entity,"WAC/T45/warning.wav"),
        LowHealth=CreateSound(self.Entity,"WAC/T45/engfail.wav"),
        CrashAlarm=CreateSound(self.Entity,"WAC/T45/engfail.wav"),
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
                                surface.DrawTexturedRectRotated(250+up.y*(a.p+p)
 
*dist,250-up.z*(a.p+p)*dist,300,300,a.r)
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

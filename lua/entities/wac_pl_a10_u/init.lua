include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(p, tr)
	if (!tr.Hit) then return end
	local e = ents.Create(ClassName)
	e:SetPos(tr.HitPos + tr.HitNormal*20)
	e.Owner = p
	e:Spawn()
	e:Activate()
	e:SetSkin(math.random(0,3))	
	return e
end

ENT.AutomaticFrameAdvance = true // needed for gear anims

ENT.Aerodynamics = {
	Rotation = {
		Front = Vector(0, 0, 0),
		Right = Vector(0, 0, 40), -- Rotate towards flying direction
		Top = Vector(0, -40, 0)
	},
	Lift = {
		Front = Vector(0, 0, 10), -- Go up when flying forward
		Right = Vector(0, 0, 0),
		Top = Vector(0, 0, -0.5)
	},
	Rail = Vector(1, 5, 20),
	Drag = {
		Directional = Vector(0.01, 0.01, 0.01),
		Angular = Vector(0.01, 0.01, 0.01)
	}
}

function ENT:PhysicsUpdate(ph)
	self:base("wac_pl_base").PhysicsUpdate(self,ph)
	
	if self.rotor2 then
		local vel = ph:GetVelocity()	
		local pos = self:GetPos()
		local lvel = self:WorldToLocal(pos+vel)
		local throttle = self.controls.throttle/2 + 0.5
		local phm = FrameTime()*66
		local brake = (throttle+1)*self.rotorRpm/900+self.rotor.phys:GetAngleVelocity().z/100
		self.rotor2.phys:AddAngleVelocity(Vector(0,0,self.engineRpm*30 + throttle*self.engineRpm*20)*self.rotorDir*phm)
		self.rotor2.phys:AddAngleVelocity(Vector(0,0,-brake + lvel.x*lvel.x/500000)*self.rotorDir*phm)
	end
end

function ENT:addRotors()
	self:base("wac_pl_base").addRotors(self)

	self.rotorModel.TouchFunc=nil
	
	self.rotor2 = ents.Create("prop_physics")
	self.rotor2:SetModel("models/props_junk/sawblade001a.mdl")
	self.rotor2:SetPos(self:LocalToWorld(self.rotorPos2))
	self.rotor2:SetAngles(self:GetAngles() + Angle(90, 0, 0))
	self.rotor2:SetOwner(self.Owner)
	self.rotor2:Spawn()
	self.rotor2:SetNotSolid(true)
	self.rotor2.phys = self.rotor2:GetPhysicsObject()
	self.rotor2.phys:EnableGravity(false)
	self.rotor2.phys:SetMass(5)
	--self.rotor2.phys:EnableDrag(false)
	self.rotor2:SetNoDraw(true)
	self.rotor2.health = 100
	self.rotor2.wac_ignore = true
	if self.RotorModel2 then
		local e = ents.Create("wac_hitdetector")
		e:SetModel(self.RotorModel2)
		e:SetPos(self:LocalToWorld(self.rotorPos2))
		e:SetAngles(self:GetAngles())
		e:Spawn()
		e:SetOwner(self.Owner)
		e:SetParent(self.rotor2)
		e.wac_ignore = true
		local obb=e:OBBMaxs()
		self.RotorWidth=(obb.x>obb.y and obb.x or obb.y)
		self.RotorHeight=obb.z
		self.rotorModel2=e
		self:AddOnRemove(e)
	end
	constraint.Axis(self.Entity, self.rotor2, 0, 0, self.rotorPos2, Vector(0,0,1), 0,0,0.01,1)
	self:AddOnRemove(self.rotor2)
end

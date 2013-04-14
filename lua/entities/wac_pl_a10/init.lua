include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(p, tr)
	if (!tr.Hit) then return end
	local e = ents.Create(ClassName)
	e:SetPos(tr.HitPos + tr.HitNormal*20)
	e.Owner = p
	e:Spawn()
	e:Activate()
	e:SetSkin(math.random(0,2))
	return e
end

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
	Rail = Vector(1, 5, 20)
}

function ENT:AddRotor()
	self.TopRotor = ents.Create("prop_physics")
	self.TopRotor:SetModel("models/props_junk/sawblade001a.mdl")
	self.TopRotor:SetPos(self:LocalToWorld(self.TopRotorPos))
	self.TopRotor:SetAngles(self:GetAngles() + Angle(90, 0, 0))
	self.TopRotor:SetOwner(self.Owner)
	self.TopRotor:Spawn()
	self.TopRotor:SetNotSolid(true)
	self.TopRotor.Phys = self.TopRotor:GetPhysicsObject()
	self.TopRotor.Phys:EnableGravity(false)
	self.TopRotor.Phys:SetMass(5)
	--self.TopRotor.Phys:EnableDrag(false)
	self.TopRotor:SetNoDraw(true)
	self.TopRotor.fHealth = 100
	self.TopRotor.wac_ignore = true
	if self.RotorModel then
		local e = ents.Create("wac_hitdetector")
		e:SetModel(self.RotorModel)
		e:SetPos(self:LocalToWorld(self.TopRotorPos))
		e:SetAngles(self:GetAngles())
		e:Spawn()
		e:SetOwner(self.Owner)
		e:SetParent(self.TopRotor)
		e.wac_ignore = true
		local obb=e:OBBMaxs()
		self.RotorWidth=(obb.x>obb.y and obb.x or obb.y)
		self.RotorHeight=obb.z
		self.TopRotorModel=e
		self:AddOnRemove(e)
	end
	constraint.Axis(self.Entity, self.TopRotor, 0, 0, self.TopRotorPos, Vector(0,0,1), 0,0,0.01,1)
	self:AddOnRemove(self.TopRotor)

	if self.EngineWeight then
		local e = ents.Create("prop_physics")
		e:SetModel("models/props_junk/PopCan01a.mdl")
		e:SetPos(self:LocalToWorld(self.TopRotorPos))
		e:Spawn()
		e:SetNotSolid(true)
		e:GetPhysicsObject():SetMass(self.EngineWeight.Weight)
		constraint.Weld(self.Entity, e)
		self:AddOnRemove(e)
		self.EngineWeight.Entity = e
	end
	
	// new rotors!
	self.OtherRotor = ents.Create("prop_physics")
	self.OtherRotor:SetModel("models/props_junk/sawblade001a.mdl")
	self.OtherRotor:SetPos(self:LocalToWorld(self.OtherRotorPos))
	self.OtherRotor:SetAngles(self:GetAngles() + Angle(90, 0, 0))
	self.OtherRotor:SetOwner(self.Owner)
	self.OtherRotor:Spawn()
	self.OtherRotor:SetNotSolid(true)
	self.OtherRotor.Phys = self.OtherRotor:GetPhysicsObject()
	self.OtherRotor.Phys:EnableGravity(false)
	self.OtherRotor.Phys:SetMass(5)
	--self.OtherRotor.Phys:EnableDrag(false)
	self.OtherRotor:SetNoDraw(true)
	self.OtherRotor.fHealth = 100
	self.OtherRotor.wac_ignore = true
	if self.RotorModel then
		local e = ents.Create("wac_hitdetector")
		e:SetModel(self.RotorModel)
		e:SetPos(self:LocalToWorld(self.OtherRotorPos))
		e:SetAngles(self:GetAngles())
		e:Spawn()
		e:SetOwner(self.Owner)
		e:SetParent(self.OtherRotor)
		e.wac_ignore = true
		local obb=e:OBBMaxs()
		self.RotorWidth=(obb.x>obb.y and obb.x or obb.y)
		self.RotorHeight=obb.z
		self.OtherRotorModel=e
		self:AddOnRemove(e)
	end
	constraint.Axis(self.Entity, self.OtherRotor, 0, 0, self.OtherRotorPos, Vector(0,0,1), 0,0,0.01,1)
	self:AddOnRemove(self.OtherRotor)
end

function ENT:CustomPhysicsUpdate(ph)
	local vel = ph:GetVelocity()	
	local pos=self:GetPos()
	local lvel=self:WorldToLocal(pos+vel)
	local phm = (wac.aircraft.cvars.doubleTick:GetBool() and 2 or 1)
	if self.OtherRotor.Phys and self.OtherRotor.Phys:IsValid() and self.TopRotor and self.TopRotor.Phys and self.TopRotor.Phys:IsValid() then
		if self.Active and self.TopRotor:WaterLevel() <= 0 then
			self.OtherRotor.Phys:AddAngleVelocity(Vector(0,0,self.engineRpm*30 + self.upMul*self.engineRpm*20)*self.TopRotorDir)	
		end
		local brake = (self.upMul+1)*self.rotorRpm/900+self.OtherRotor.Phys:GetAngleVelocity().z/100
		self.OtherRotor.Phys:AddAngleVelocity(Vector(0,0,-brake + lvel.x*lvel.x/500000)*self.TopRotorDir*phm)
	end
end

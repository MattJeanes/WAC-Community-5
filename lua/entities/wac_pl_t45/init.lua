
include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent=ents.Create(ClassName)
	ent:SetPos(tr.HitPos+tr.HitNormal*70)
	ent:Spawn()
	ent:Activate()
	ent.Owner=ply	
	ent:SetSkin(math.random(0,3))
	net.Start("WAC-ModelDetailWarning")
		net.WriteString(self.PrintName)
	net.Send(ply)
	return ent
end

ENT.Aerodynamics = {
	Rotation = {
		Front = Vector(0, -4, 0),
		Right = Vector(0, 0, 20), -- Rotate towards flying direction
		Top = Vector(0, -20, 0)
	},
	Lift = {
		Front = Vector(0, 0, 1.25), -- Go up when flying forward
		Right = Vector(0, 0, 0),
		Top = Vector(0, 0, -0.25)
	},
	Rail = Vector(1, 5, 20),
	Drag = {
		Directional = Vector(0.01, 0.01, 0.01),
		Angular = Vector(0.1, 0.05, 0.01)
	}
}

function ENT:addRotors()
	self:base("wac_pl_base").addRotors(self)
	
	self.rotorModel.TouchFunc=nil
end
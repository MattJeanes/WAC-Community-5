if not wac then return end
AddCSLuaFile('shared.lua')

ENT.Base	= "wac_hc_base"
ENT.Type	= "anim"

function ENT:PhysicsCollide(cdat, phys)
end

function ENT:DamageSmallRotor(amt)
end

function ENT:KillBackRotor()
end

function ENT:DamageBigRotor(amt)
end

function ENT:KillTopRotor()
end

function ENT:OnTakeDamage(dmg)
end

function ENT:DamageEngine(amt)
end

function ENT:CreateSmoke()
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent=ents.Create(ClassName)
	ent:SetPos(tr.HitPos+tr.HitNormal*2)
	ent.Owner=ply
	ent:Spawn()
	ent:Activate()
	self.Sounds=table.Copy(sndt)
	return ent
end
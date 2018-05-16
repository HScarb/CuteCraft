# ActorAttackGhost.gd
# 幽灵攻击动作演算体
extends "res://scripts/Actor/ActorAttack.gd"

# override
func check_type_launch(type_name):
	if type_name == "WeaponGhostLaunchRay":
		return true
	return false

# override
func check_type_impact(type_name):
	if type_name == "WeaponGhostDamage":
		return true
	return false

# ActorAttackImmortal.gd
# Immortal攻击动作演算体
extends "res://scripts/Actor/ActorAttack.gd"

# override
func check_type_launch(type_name):
	if type_name == "WeaponImmortalLaunchRay":
		return true
	return false

# override
func check_type_impact(type_name):
	if type_name == "WeaponImmortalDamage":
		return true
	return false

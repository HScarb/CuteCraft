# ActorAttackStalker.gd
# 追猎者攻击演算体
extends "res://scripts/Actor/ActorAttack.gd"

# override
func check_type_launch(type_name):
	if type_name == "StalkerLaunchMissile":
		return true
	return false

# override
func check_type_impact(type_name):
	if type_name == "WeaponStalkerDamage":
		return true
	return false

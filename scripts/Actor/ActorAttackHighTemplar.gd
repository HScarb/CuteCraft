# ActorAttackHighTemplar.gd
# 电兵攻击演算体
extends "res://scripts/Actor/ActorAttack.gd"

# override
func check_type_launch(type_name):
	if type_name == "HighTemplarLaunchMissile":
		return true
	return false

# override
func check_type_impact(type_name):
	if type_name == "WeaponHighTemplarDamage":
		return true
	return false

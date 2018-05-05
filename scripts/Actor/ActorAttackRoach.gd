# ActorAttackRoach.gd
# 蟑螂攻击演算体
extends "res://scripts/Actor/ActorAttack.gd"

# override
func check_type_launch(type_name):
	if type_name == "RoachLaunchMissile":
		return true
	return false

# override
func check_type_impact(type_name):
	if type_name == "WeaponRoachDamage":
		return true
	return false

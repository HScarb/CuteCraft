# ActorAttackMarine.gd
# Marine攻击动作演算体
extends "res://scripts/Actor/ActorAttack.gd"

# override
func init():
	SignalManager.connect("weapon_start", self, "play_launch_animation")
	SignalManager.connect("effect_start", self, "play_impact_animation")
	pass

# override
func check_type_launch(type_name):
	if type_name == "WeaponMarine":
		return true
	return false

func check_type_impact(type_name):
	return false
# ActorUnitStalker.gd
# Stalker单位演算体
extends "res://scripts/Actor/ActorUnit.gd"

# override
func check_type(type_name):
	if type_name.ends_with("Stalker"):
		return true
	return false
extends "res://scripts/Actor/ActorUnit.gd"

func init():
	SignalManager.connect("unit_birth", self, "create_model")

# override
func check_create_unit_type(unit_type_name):
	if unit_type_name.ends_with("Marine"):
		return true
	return false
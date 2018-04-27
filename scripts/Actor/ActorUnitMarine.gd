extends "res://scripts/Actor/ActorUnit.gd"

# override
func init():
	# unit_birth(unit)
	SignalManager.connect("unit_birth", self, "create_model")

# override
func check_type(type_name):
	if type_name.ends_with("Marine"):
		return true
	return false
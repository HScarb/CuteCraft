# ActorUnitGhost.gd
extends "res://scripts/Actor/ActorUnit.gd"

# override
func check_type(type_name):
    if type_name.ends_with("Ghost"):
        return true
    return false

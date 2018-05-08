# ActorStalkerMissile.gd
# 蟑螂发射物演算体
extends "res://scripts/Actor/ActorUnit.gd"

# override
func check_type(type_name):
    if type_name == "StalkerMissile":
        return true
    return false
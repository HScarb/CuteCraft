# ActorBeamImmortal.gd
# 不朽爸爸攻击光束演算体
extends "res://scripts/Actor/ActorBeam.gd"

# override
func init():
    SignalManager.connect("effect_start", self, "create_beam")

func check_type(type_name):
    if type_name == "WeaponImmortalDamage":
        return true
    return false

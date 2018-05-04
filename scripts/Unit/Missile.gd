# Missile.gd
# 发射物
extends "res://scripts/Unit/Unit.gd"

var effect_impact = null                        # 轰击效果

###### 状态切换条件 ######
func get_on_move_condi():
    if is_dead:
        return false
    return true
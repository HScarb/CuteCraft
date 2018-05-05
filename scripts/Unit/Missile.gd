# Missile.gd
# 发射物
extends "res://scripts/Unit/Unit.gd"

var parent_unit = null                          # 发射该子弹的单位
var effect_impact = null                        # 轰击效果

###### 状态切换条件 ######
func get_on_move_condi():
    if is_dead:
        return false
    return true

func impact():
    if effect_impact != null:
        effect_impact.run()
    queue_free()

func _on_BodyArea_area_entered(area):
    print("area_enter")
    var target_unit = area.get_parent()
    if parent_unit == target_unit:
        return
    impact()
    pass # replace with function body

func _on_BodyArea_body_entered(body):
    print("body_enter")
    pass # replace with function body
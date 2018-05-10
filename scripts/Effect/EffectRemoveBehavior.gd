# EffectRemoveBehavior.gd
# 移除行为效果
extends "res://scripts/Effect/Effect.gd"

export(String) var behavior_name = null
export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var unit_location = 7                           # 需要被传送的单位，只能是单位

func run():
    .run()
    if behavior_name == null:
        return
    var data_unit = get_unit_by_target_data_type(unit_location)
    if typeof(data_unit) == TYPE_ARRAY:
        for unit in data_unit:
            unit.remove_behavior(behavior_name)
    else:
        data_unit.remove_behavior(behavior_name)
        
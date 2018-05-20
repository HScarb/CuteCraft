# EffectSuiside.gd
# 自杀
extends "res://scripts/Effect/Effect.gd"

export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var at_location = 3

func run():
    .run()
    var target_data = get_unit_by_target_data_type(at_location)
    if typeof(target_data) == TYPE_ARRAY:
        for unit in target_data:
            unit.die()
    else:
        target_data.die()

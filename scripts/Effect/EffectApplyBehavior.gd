# EffectApplyBehavior.gd
# 应用行为效果
extends "res://scripts/Effect/Effect.gd"

export(PackedScene) var behavior = null                     # 行为
export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var unit_location = 7                           # 需要被传送的单位，只能是单位

func run():
    .run()
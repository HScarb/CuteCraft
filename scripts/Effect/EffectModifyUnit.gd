# EffectModifyUnit.gd
# 修改单位效果
extends "res://scripts/Effect/Effect.gd"

export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var launch_location = 3                         # 效果发起单位
export(PackedScene) var launch_effect = null    # 对发起单位引发的效果
export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var target_location = 7                         # 效果目标单位
export(PackedScene) var impact_effect = null    # 对目标单位引发的效果
###### 修改单位 ######
export(float) var life_max = 0
export(float) var life = 0
export(float) var life_recover = 0
export(float) var enegy_max = 0
export(float) var enegy = 0
export(float) var enegy_recover = 0
export(float) var speed = 0
export(float) var acceleration = 0
export(float) var attack_speed_multi = 0

func run():
    .run()
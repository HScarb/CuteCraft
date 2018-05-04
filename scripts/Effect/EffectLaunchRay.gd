# EffectLaunchRay.gd
# 发射射线
# 目标数据保持不变
extends "res://scripts/Effect/Effect.gd"

export(PackedScene) var launch_effect = null            # 发射效果
export(PackedScene) var impact_effect = null            # 轰击效果
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var launch_location = 3                             # 发射位置，默认是源单位
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var impact_location = 6                             # 轰击位置，默认是目标点

func run():
    .run()
    var raycast = RayCast2D.new()
    raycast.enabled = true
    var unit = get_data_by_target_data_type(launch_location)
    var origin = self.effect_origin
    if not unit is load("res://scripts/Unit/Unit.gd"):
        return
    unit.model.get_muzzle().add_child(raycast)
    
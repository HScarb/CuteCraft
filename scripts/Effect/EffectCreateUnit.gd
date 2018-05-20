# EffectCreateUnit.gd
# 创建单位效果
extends "res://scripts/Effect/Effect.gd"

export(PackedScene) var unit_type = null                # 单位类型
export(PackedScene) var effect_spawn = null             # 生成单位时的效果
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var target_origin = 5
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var target_location = 6

var class_unit = load("res://scripts/Unit.gd")

func run():
    .run()
    var spawn_pos = get_pos_by_target_data_type(target_location)
    if spawn_pos == null:
        print("[Error]EffectCreateUnit.run: spawn_pos == null")
        return
    var unit_spawned = UnitManager.create_unit_by_type(unit_type, spawn_pos)
    if effect_spawn != null:
        var sub_effect = effect_spawn.instance()
        # 传递目标数据
        .trans_target_data(sub_effect)
        # 子效果的目标单位为新创建出来的单位
        sub_effect.target_unit = unit_spawned

        sub_effect.run()
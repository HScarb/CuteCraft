# EffectTeleport.gd
# 传送效果
extends "res://scripts/Effect/Effect.gd"

export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var source_location = 5                         # 效果源单位
export(PackedScene) var source_effect = null    # 对于源单位引发的效果
export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var unit_location = 7                           # 需要被传送的单位，只能是单位
export(PackedScene) var unit_effect = null      # 对于被传送单位运行的效果
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var target_location = 6                         # 传送的目标点
export(PackedScene) var target_effect = null    # 在目标点运行的效果
export(float) var teleport_range = -1           # 传送(最大)距离

func run():
    .run()
    # 获取需要被传送的单位
    var teleport_unit_list = []
    var teleport_unit = get_unit_by_target_data_type(unit_location)
    if typeof(teleport_unit) == TYPE_ARRAY:
        for tu in teleport_unit:
            teleport_unit_list.append(tu)
    elif teleport_unit == null:
        pass
    else:
        teleport_unit_list.append(teleport_unit)
    # 获取传送目标点
    var teleport_pos = null                     # 真正传送点
    var target_pos = get_pos_by_target_data_type(target_location)
    if typeof(target_pos) == TYPE_ARRAY:
        target_pos = target_pos[0]
    teleport_pos = target_pos
    # 根据传送距离计算真正传送点
    # 传送源点
    var source_pos = get_pos_by_target_data_type(source_location)
    if teleport_range >= 0:
        # 计算源点到目标点的角度
        var rad = source_pos.angle_to_point(teleport_pos)
        var teleport_vector = Vector2(cos(rad) * teleport_range, sin(rad) * teleport_range)
        teleport_pos = source_pos + teleport_vector
    # 运行效果
    #   源单位效果
    if source_effect != null:
        var effect_source = source_effect.instance()
        trans_target_data(effect_source)
        effect_source.target_unit = [get_unit_by_target_data_type(source_location)]
        effect_source.run()
    #   被传送的单位效果
    if unit_effect != null:
        for u in teleport_unit_list:
            var effect_unit = unit_effect.instance()
            trans_target_data(effect_unit)
            effect_unit.target_unit = [u]
            effect_unit.run()
    #   目标效果
    if target_effect != null:
        var effect_target = target_effect.instance()
        trans_target_data(effect_target)
        effect_target.target_point = teleport_pos
        effect_target.run()
    # 传送
    for tu in teleport_unit_list:
        tu.set_position(teleport_pos)
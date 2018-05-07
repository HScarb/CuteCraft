# ActorBeam.gd
# 光束演算体
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var start_location = 5
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var end_location = 6

func create_beam(effect_tree_node):
    # 检测类型
    if not check_name(effect_tree_node):
        return
    if model == null:
        return
    print("LAUNCH BEAM")
    # 从效果中获取开始位置和结束位置
    var start_pos = Vector2()
    var end_pos = Vector2()
    var start_data = effect_tree_node.get_data_by_target_data_type(start_location)
    if typeof(start_data) == TYPE_VECTOR2:
        start_pos = start_data
    else:
        start_pos = start_data.model.get_muzzle().position + start_data.position
    end_pos = effect_tree_node.get_pos_by_target_data_type(end_location)
    print("muzzle: ", start_data.model.get_muzzle().position)
    print("unit: ", start_data.position)
    print("start, end", start_pos, end_pos)
    # 建立光束模型
    var new_model = model.instance()
    # 调整模型光束
    new_model.set_region_rect(Rect2(0, 0, start_pos.distance_to(end_pos), 1))
    new_model.set_rotation(end_pos.angle_to_point(start_pos))
    new_model.set_position(start_pos)
    MapManager.get_layer_front().add_child(new_model)
    new_model.play_animation()
    
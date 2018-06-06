# ActorBeam.gd
# 光束演算体
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var start_location = 2
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var end_location = 6
export(int) var beam_width = 1

# override
func init():
    SignalManager.connect("effect_start", self, "create_beam")

func create_beam(effect_tree_node):
    # 检测类型
    if not check_name(effect_tree_node):
        return
    if model == null:
        return
    # 从效果中获取开始位置和结束位置
    var start_pos = Vector2()
    var end_pos = Vector2()
    var start_data = effect_tree_node.get_pos_by_target_data_type(start_location)
    if typeof(start_data) == TYPE_ARRAY:
        start_pos = start_data[0]
    else:
        start_pos = start_data
        # start_pos = start_data.model.get_muzzle().position + start_data.position
        # start_pos = effect_tree_node.effect_origin.get_muzzle().position + start_data.position
    end_pos = effect_tree_node.get_pos_by_target_data_type(end_location)
    # 建立光束模型
    var new_model = model.instance()
    # 调整模型光束
    new_model.sprite.set_region_rect(Rect2(0, 0, start_pos.distance_to(end_pos), beam_width))
    new_model.sprite.set_rotation(end_pos.angle_to_point(start_pos))
    new_model.sprite.set_position(start_pos)
    MapManager.get_layer_front().add_child(new_model)
    new_model.play_animation()
    
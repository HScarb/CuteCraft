# ActorModel.gd
# 模型演算体
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var at_location = 6             # 序列帧动画创建的位置

func init():
    SignalManager.connect("effect_start", self, "play_model_animation")

func play_model_animation(effect_tree_node):
    if self.model == null:
        return
    if not check_name(effect_tree_node):
        return
    var new_model = null
    var model_pos = effect_tree_node.get_pos_by_target_data_type(at_location)
    if typeof(model_pos) == TYPE_ARRAY:
        new_model = []
        for pos in model_pos:
            new_model.append(create_animated_model(model, MapManager.get_layer_front(), pos))
    else:
        new_model = create_animated_model(model, MapManager.get_layer_front(), pos)
    return new_model

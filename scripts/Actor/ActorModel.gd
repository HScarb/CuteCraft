# ActorModel.gd
# 模型演算体
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var at_location = 6             # 序列帧动画创建的位置

var model_instance = null       # 演算体所创建的模型

func init():
    SignalManager.connect("effect_start", self, "play_model_animation")

func play_model_animation(effect_tree_node):
    if self.model == null:
        return
    if not check_name(effect_tree_node):
        return
    var new_model = add_model_at_location(effect_tree_node, model, at_location)
    model_instance = new_model
    return new_model

func destroy_model(effect_tree_node):
    if not check_name(effect_tree_node):
        return
    if model_instance != null:
        model_instance.queue_free()

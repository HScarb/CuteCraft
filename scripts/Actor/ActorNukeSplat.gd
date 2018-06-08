# ActorNukeSplat.gd
extends "res://scripts/Actor/ActorModel.gd"

# override
func play_model_animation(effect_tree_node):
    if self.model == null:
        return
    if not check_name(effect_tree_node):
        return
    var new_model = add_model_at_location(effect_tree_node, model, at_location, false, Global.MAP_LAYER_GROUND)
    model_instance = new_model
    return new_model

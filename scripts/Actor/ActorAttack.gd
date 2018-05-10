# ActorAttack.gd
# 攻击动作演算体
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var launch_model = null
export(PackedScene) var impact_model = null
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var launch_location = 5
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var impact_location = 7

# override
func init():
	SignalManager.connect("effect_start", self, "play_launch_animation")
	SignalManager.connect("effect_start", self, "play_impact_animation")
	pass

# virtual
# 用于检测传入参数类型是否是演算体launch对应的类型
func check_type_launch(type_name):
	return false

# virtual
# 用于检测传入参数类型是否是演算体impact对应的类型
func check_type_impact(type_name):
	return false

# 创建并播放发射动画
func play_launch_animation(effect_tree_node):
	if launch_model == null:
		return
	# 检测类型
	if not check_name(effect_tree_node, "check_type_launch"):
		return
	# 创建发射动画模型
	var new_launch_model = add_model_at_location(effect_tree_node, launch_model, launch_location, true)
	# # 获取单位
	var unit = effect_tree_node.get_unit_by_target_data_type(launch_location)
	# 根据朝向进行形变
	new_launch_model.modify_by_direction(unit.face_direction)
	
	return new_launch_model

# 创建并播放轰击动画
func play_impact_animation(effect_tree_node):
	if self.impact_model == null:
		return
	# 检测类型
	if not check_name(effect_tree_node, "check_type_impact"):
		return
	# 创建轰击动画模型
	var new_impact_model = add_model_at_location(effect_tree_node, impact_model, impact_location)
	return new_impact_model
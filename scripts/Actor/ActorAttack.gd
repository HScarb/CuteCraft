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
	if self.launch_model == null:
		return
	# 检测类型
	var node_name = effect_tree_node.get_name()
	if not check_type_launch(node_name):
		return
	# 获取单位
	var unit = effect_tree_node.get_unit_by_target_data_type(launch_location)
	# 创建动画精灵
	var new_launch_model = launch_model.instance()
	new_launch_model.init()
	# 根据朝向进行形变
	new_launch_model.modify_by_direction(unit.face_direction)
	# 添加到父节点
	unit.model.get_muzzle().add_child(new_launch_model)
	
	return new_launch_model

# 创建并播放轰击动画
func play_impact_animation(effect_tree_node):
	if self.impact_model == null:
		return
	# 检测类型
	var node_name = effect_tree_node.get_name()
	if not check_type_impact(node_name):
		return
	# 获取目标单位或点
	var impact_pos = effect_tree_node.get_pos_by_target_data_type(impact_location)
	# 创建新的轰击模型
	var new_impact_model = impact_model.instance()
	new_impact_model.init()
	new_impact_model.set_position(impact_pos)
	# 添加到地图
	MapManager.get_layer_unit().add_child(new_impact_model)
	# if impact_location % 2 == 0:
	# 	# 如果目标类型是点
	# 	var impact_pos = effect_tree_node.get_pos_by_target_data_type(impact_location)
	# 	impact_sprite = create_animated_sprite(impact_frames, MapManager.get_layer_unit(), impact_pos)
	# else:
	# 	# 如果目标类型是单位
	# 	var target_unit = effect_tree_node.get_unit_by_target_data_type(impact_location)
	# 	if typeof(target_unit) == TYPE_ARRAY:
	# 		# 如果是单位组
	# 		impact_sprite = []
	# 		for unit in target_unit:
	# 			impact_sprite.append(create_animated_sprite(impact_frames, unit.model.get_impact_node()))
	# 	else:
	# 		# 如果是单个单位
	# 		if target_unit != null:
	# 			impact_sprite = create_animated_sprite(impact_frames, target_unit.model.get_impact_node())
	return new_impact_model
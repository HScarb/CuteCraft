# ActorAnimation
extends Node

export(String) var check_type_name = null

# virtual
# 这里注册全局监听信号事件
func init():
	pass

# 使用check_type检查node的名称
func check_name(node, check_func = "check_type"):
	var file_name = Global.get_node_name(node)
	var ret = call(check_func, file_name)
	return ret

# virtual
# 用于检测传入参数的类型是否是演算体对应的类型(根据名称判断)，需要派生类重载
func check_type(type_name):
	if check_type_name != null:
		return type_name == check_type_name
	return false

# 创建序列帧动画(废弃)
# sprite_frames: [SpriteFrames]
# parent_node: [Node2D]
# pos: [Vector2]
# return: [SpriteFrames]
func create_animated_sprite(sprite_frames, parent_node, pos = null):
	if sprite_frames == null or parent_node == null:
		return
	if pos == null:
		pos = Vector2(0 ,0)
	var animated_sprite = AnimatedSprite.new()
	animated_sprite.frames = sprite_frames
	animated_sprite.set_position(pos)
	animated_sprite.connect("tree_entered", animated_sprite, "play")
	animated_sprite.connect("animation_finished", animated_sprite, "queue_free")
	parent_node.add_child(animated_sprite)
	return animated_sprite

# 创建序列帧动画
# model_scene: [PackedScene]
# parent_node: [Node2D]
# pos: [Vector2]
# return: [Model.gd]
func create_animated_model(model_scene, parent_node, pos = null):
	if model_scene == null or parent_node == null:
		return
	if pos == null:
		pos = Vector2(0, 0)
	# 创建新的模型
	var new_model = model_scene.instance()
	# 进入场景树后开始播放动画
	new_model.init()
	new_model.set_position(pos)
	# 添加到父节点
	parent_node.add_child(new_model)
	return new_model

# 根据传入地点的不同将模型添加到指定位置
# 	如果传入地点类型是单位，则模型附着在单位上或单位炮口上
# 	如果传入地点类型是点，则模型附着在前景层的相应位置
# effect_tree_node: [EffectTreeNode.gd]
# model: [Model.tscn]
# at_location: [TARGET_DATA_TYPE]
# at_muzzle: [bool]是否附着在单位炮口
func add_model_at_location(effect_tree_node, model_type, at_location, at_muzzle = false):
	var new_model = null
	if Global.is_target_data_unit(at_location):
		# 如果目标数据类型是单位
		var target_data = effect_tree_node.get_unit_by_target_data_type(at_location)
		if typeof(target_data) == TYPE_ARRAY:
			new_model = []
			for unit in target_data:
				if at_muzzle:
					new_model.append(create_animated_model(model_type, unit.model.get_muzzle()))
				else:
					new_model.append(create_animated_model(model_type, unit.model))
		else:
			if at_muzzle:
				new_model = create_animated_model(model_type, target_data.model.get_muzzle())
			else:
				new_model = create_animated_model(model_type, target_data.model)
	else:
		# 如果目标数据类型是点
		var target_data = effect_tree_node.get_pos_by_target_data_type(at_location)
		if typeof(target_data) == TYPE_ARRAY:
			new_model = []
			for pos in target_data:
				var model = create_animated_model(model_type, MapManager.get_layer_front())
				if model != null:
					model.set_position(pos)
					new_model.append(model)
		else:
			new_model = create_animated_model(model_type, MapManager.get_layer_front())
			if new_model != null:
				new_model.set_position(target_data)
	return new_model
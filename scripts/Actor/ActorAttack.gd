# ActorAttack.gd
# 攻击动作演算体
extends "res://scripts/Actor/Actor.gd"

export(SpriteFrames) var launch_frames = null
export(SpriteFrames) var impact_frames = null
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
	if self.launch_frames == null:
		return
	# 检测类型
	var node_name = effect_tree_node.get_name()
	if not check_type_launch(node_name):
		return
	# 获取单位
	var unit = effect_tree_node.get_unit_by_target_data_type(launch_location)
	# 创建动画精灵
	var launch_sprite = .create_animated_sprite(launch_frames, unit.model.get_muzzle())
	# 设置缩放等
	match unit.face_direction:
		Global.FACE_DIRECTION.north:
			launch_sprite.set_scale(Vector2(0.1, 0.4))
			launch_sprite.set_offset(Vector2(-90, 0))
		Global.FACE_DIRECTION.north_east:
			launch_sprite.set_scale(Vector2(0.28, 0.4))
			launch_sprite.set_flip_h(true)
			launch_sprite.set_offset(Vector2(90, 0))
			launch_sprite.set_rotation_degrees(-18)
		Global.FACE_DIRECTION.east:
			launch_sprite.set_scale(Vector2(0.4, 0.4))
			launch_sprite.set_offset(Vector2(90, 0))
			launch_sprite.set_flip_h(true)
			launch_sprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.south_east:
			launch_sprite.set_scale(Vector2(0.28, 0.4))
			launch_sprite.set_offset(Vector2(90, 0))
			launch_sprite.set_flip_h(true)
			launch_sprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.south:
			launch_sprite.set_scale(Vector2(0.2, 0.4))
			launch_sprite.set_offset(Vector2(90, 0))
			launch_sprite.set_flip_h(true)
			launch_sprite.set_z_index(Global.Z_INDEX_UNIT)
			launch_sprite.set_rotation_degrees(90)
		Global.FACE_DIRECTION.south_west:
			launch_sprite.set_scale(Vector2(0.28, 0.4))
			launch_sprite.set_offset(Vector2(-90, 0))
			launch_sprite.set_z_index(Global.Z_INDEX_UNIT)
			launch_sprite.set_rotation_degrees(-18)
		Global.FACE_DIRECTION.west:
			launch_sprite.set_scale(Vector2(0.4, 0.4))
			launch_sprite.set_offset(Vector2(-90, 0))
			launch_sprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.north_west:
			launch_sprite.set_scale(Vector2(0.28, 0.4))
			launch_sprite.set_offset(Vector2(-90, 0))
			launch_sprite.set_rotation_degrees(18)
	return launch_sprite

# 创建并播放轰击动画
func play_impact_animation(effect_tree_node):
	if self.impact_frames == null:
		return
	# 检测类型
	var node_name = effect_tree_node.get_name()
	if not check_type_impact(node_name):
		return
	# 动画精灵
	var impact_sprite = null
	# 获取目标单位或点
	if impact_location % 2 == 0:
		# 如果目标类型是点
		var impact_pos = effect_tree_node.get_pos_by_target_data_type(impact_location)
		impact_sprite = .create_animated_sprite(impact_frames, impact_pos)
	else:
		# 如果目标类型是单位
		var target_unit = effect_tree_node.get_unit_by_target_data_type(impact_location)
		if typeof(target_unit) == TYPE_ARRAY:
			# 如果是单位组
			impact_sprite = []
			for unit in target_unit:
				impact_sprite.append(.create_animated_sprite(impact_frames, unit.model.get_impact_node()))
		else:
			# 如果是单个单位
			if target_unit != null:
				impact_sprite = .create_animated_sprite(impact_frames, target_unit.model.get_impact_node())

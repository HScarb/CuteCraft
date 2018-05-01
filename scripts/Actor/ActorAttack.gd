# ActorAttack.gd
# 攻击动作演算体
extends "res://scripts/Actor/Actor.gd"

export(SpriteFrames) var launch_frames = null
export(SpriteFrames) var impact_frames = null
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var launch_location = 5
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var impact_location = 6

# override
func init():
	# SignalManager.connect("weapon_start", self, "play_launch_animation")
	pass

# virtual
# 用于检测传入参数类型是否是演算体launch对应的类型
func check_type_launch(type_name):
	return false

# virtual
# 用于检测传入参数类型是否是演算体impact对应的类型
func check_type_impact(type_name):
	return false

# 创建发射动画
# weapon: weapon.gd
func play_launch_animation(effect_tree_node):
	# 检测类型
	var node_name = effect_tree_node.get_name()
	if not check_type_launch(node_name):
		return
	# 从武器获取源单位
	var weapon = null
	if effect_tree_node is load("res://scripts/Weapon/Weapon.gd"):
		weapon = effect_tree_node
	else:
		weapon = effect_tree_node.effect_origin
	if weapon == null:
		return
	var unit = weapon.logicRoot
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
	pass

func play_impact_animation(effect_tree_node):
	# 检测类型
	var node_name = effect_tree_node.get_name()
	if not check_type_impact(node_name):
		return
	# 创建动画
	var sprite_pos = effect_tree_node.get_pos_by_target_data_type()
	pass

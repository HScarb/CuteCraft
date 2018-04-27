# ActorAttack.gd
# 攻击动作演算体
extends "res://scripts/Actor/Actor.gd"

export(SpriteFrames) var launch_frames = null
export(SpriteFrames) var impact_frames = null

# override
func init():
	# SignalManager.connect("weapon_start", self, "play_launch_animation")
	pass

# 创建发射动画
# weapon: weapon.gd
func play_launch_animation(weapon):
	print("play_launch_animation")
	# 检测类型
	var weapon_name = weapon.get_name()
	if not check_type(weapon_name):
		return
	# 从武器获取源单位
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
	
	pass

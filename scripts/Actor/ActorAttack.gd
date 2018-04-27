# ActorAttack.gd
# 攻击动作演算体
extends "res://scripts/Actor/Actor.gd"

export(SpriteFrames) var launch_frames = null
export(SpriteFrames) var impact_frames = null

onready var logicRoot = $".."

func _ready():
	pass

func play_launch_animation(effect_tree_node):
	var launch_sprite = create_effect(launch_frames, logicRoot.model.get_muzzle())
	# 设置缩放等
	match logicRoot.face_direction:
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
	print("play_impact_animation", effect_tree_node)
	pass

# 创建特效动画
# sprite_frames: [SpriteFrames]
# parent_node: [Node2D]
# under_node: [bool]
# return: [SpriteFrames]
func create_effect(sprite_frames, parent_node):
	if sprite_frames == null or parent_node == null:
		return
	var animated_sprite = AnimatedSprite.new()
	animated_sprite.frames = sprite_frames
	animated_sprite.connect("tree_entered", animated_sprite, "play")
	animated_sprite.connect("animation_finished", animated_sprite, "queue_free")
	parent_node.add_child(animated_sprite)
	return animated_sprite
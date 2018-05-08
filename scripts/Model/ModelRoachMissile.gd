# ModelRoachMissile.gd
# 蟑螂发射物模型
extends "res://scripts/Model/Model.gd"

func modify_by_direction(direction):
	match direction:
		Global.FACE_DIRECTION.east:
			$AnimatedSprite.set_scale(Vector2(1, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.south_east:
			$AnimatedSprite.set_scale(Vector2(0.7, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(24)
		Global.FACE_DIRECTION.south:
			$AnimatedSprite.set_scale(Vector2(0.5, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(90)
		Global.FACE_DIRECTION.south_west:
			$AnimatedSprite.set_scale(Vector2(0.7, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(-24)
		Global.FACE_DIRECTION.west:
			$AnimatedSprite.set_scale(Vector2(1, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.north_west:
			$AnimatedSprite.set_scale(Vector2(0.7, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_rotation_degrees(24)
		Global.FACE_DIRECTION.north:
			$AnimatedSprite.set_scale(Vector2(0.5, 1) * scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_rotation_degrees(90)
		Global.FACE_DIRECTION.north_east:
			$AnimatedSprite.set_scale(Vector2(0.7, 1) * scale_factor)
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_rotation_degrees(-24)
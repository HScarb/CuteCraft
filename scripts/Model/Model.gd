# Model.gd
# 模型(包含一个动画精灵)
extends Node2D

export(bool)var free_after_finished = false					# 是否在动画结束之后销毁

var logicRoot

func init_by_unit(unit):
	unit.add_child(self)
	unit.model = self
	self.logicRoot = unit
	self.logicRoot.connect("play_animation", self, "play_animation")
	self.logicRoot.connect("stop_animation", self, "stop_animation")

func init():
    self.connect("tree_entered", $AnimatedSprite, "play")

# 根据动画名称播放动画，如果动画名称不存在则播放默认动画
func play_animation(animation_name = null):
	if animation_name == null:
		$AnimatedSprite.play("default")
		return
	# 尝试播放动画
	# 如果没有该动画则播放默认
	var sprite_frames = $AnimatedSprite.get_sprite_frames()
	if sprite_frames.has_animation(animation_name):
		$AnimatedSprite.play(animation_name)
	else:
		$AnimatedSprite.play("default")

# 停止播放动画
func stop_animation():
	$AnimatedSprite.stop()

# 获取播放动画的名称
func get_playing_animation():
	return $AnimatedSprite.animation

# 获取动画是否在播放中
func is_playing():
	return $AnimatedSprite.is_playing()

func modify_by_direction(direction):
	match direction:
		Global.FACE_DIRECTION.north:
			$AnimatedSprite.set_scale(Vector2(0.1, 0.4))
			$AnimatedSprite.set_offset(Vector2(-90, 0))
		Global.FACE_DIRECTION.north_east:
			$AnimatedSprite.set_scale(Vector2(0.28, 0.4))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_rotation_degrees(-18)
		Global.FACE_DIRECTION.east:
			$AnimatedSprite.set_scale(Vector2(0.4, 0.4))
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.south_east:
			$AnimatedSprite.set_scale(Vector2(0.28, 0.4))
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.south:
			$AnimatedSprite.set_scale(Vector2(0.2, 0.4))
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(90)
		Global.FACE_DIRECTION.south_west:
			$AnimatedSprite.set_scale(Vector2(0.28, 0.4))
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(-18)
		Global.FACE_DIRECTION.west:
			$AnimatedSprite.set_scale(Vector2(0.4, 0.4))
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.north_west:
			$AnimatedSprite.set_scale(Vector2(0.28, 0.4))
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_rotation_degrees(18)

# 动画播放结束调用
func _on_AnimatedSprite_animation_finished():
	if free_after_finished:
		queue_free()
	pass # replace with function body

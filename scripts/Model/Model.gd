# Model.gd
# 模型(包含一个动画精灵)
extends Node2D

export(bool)var free_after_finished = false					# 是否在动画结束之后销毁
export(float) var scale_factor = 1

var logicRoot

func init_by_unit(unit):
	unit.add_child(self)
	unit.model = self
	self.logicRoot = unit
	self.logicRoot.connect("play_animation", self, "play_animation")
	self.logicRoot.connect("stop_animation", self, "stop_animation")

func init():
	$AnimatedSprite.set_scale(Vector2(1, 1) * scale_factor)
	self.connect("tree_entered", $AnimatedSprite, "play")

# 根据动画名称播放动画，如果动画名称不存在则播放默认动画
func play_animation(animation_name = null):
	if animation_name == null:
		$AnimatedSprite.play("default")
		return
	# 尝试播放动画
	var full_animation_name = animation_name						# 最终动画全名
	if animation_name.begins_with("stand")\
        or animation_name.begins_with("move")\
		or animation_name.begins_with("attack"):
		full_animation_name = animation_name + "_%d" % logicRoot.face_direction
	# 如果没有该动画则播放默认
	var sprite_frames = $AnimatedSprite.get_sprite_frames()
	if sprite_frames.has_animation(full_animation_name):
		$AnimatedSprite.play(full_animation_name)
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

func get_animated_sprite():
	return $AnimatedSprite

func modify_by_direction(direction):
	var scale = $AnimatedSprite.get_scale()
	match direction:
		Global.FACE_DIRECTION.east:
			$AnimatedSprite.set_scale(Vector2(scale.x,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.south_east:
			$AnimatedSprite.set_scale(Vector2(scale.x*0.7,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(45)
		Global.FACE_DIRECTION.south:
			$AnimatedSprite.set_scale(Vector2(scale.x*0.5,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(90)
		Global.FACE_DIRECTION.south_west:
			$AnimatedSprite.set_scale(Vector2(scale.x*0.7,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
			$AnimatedSprite.set_rotation_degrees(-45)
		Global.FACE_DIRECTION.west:
			$AnimatedSprite.set_scale(Vector2(scale.x,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_z_index(Global.Z_INDEX_UNIT)
		Global.FACE_DIRECTION.north_west:
			$AnimatedSprite.set_scale(Vector2(scale.x*0.7,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_rotation_degrees(45)
		Global.FACE_DIRECTION.north:
			$AnimatedSprite.set_scale(Vector2(scale.x*0.25,scale.y)*scale_factor)
			$AnimatedSprite.set_offset(Vector2(-90, 0))
			$AnimatedSprite.set_rotation_degrees(90)
		Global.FACE_DIRECTION.north_east:
			$AnimatedSprite.set_scale(Vector2(scale.x*0.7,scale.y)*scale_factor)
			$AnimatedSprite.set_flip_h(true)
			$AnimatedSprite.set_offset(Vector2(90, 0))
			$AnimatedSprite.set_rotation_degrees(-45)

# 动画播放结束调用
func _on_AnimatedSprite_animation_finished():
	if free_after_finished:
		queue_free()
	pass # replace with function body

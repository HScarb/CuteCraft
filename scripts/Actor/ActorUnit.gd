extends "res://scripts/Actor/Actor.gd"

onready var logicRoot = $".."

func _ready():
	logicRoot.connect("play_animation", self, "play_animation")
	logicRoot.connect("stop_animation", self, "stop_animation")
	pass

func play_animation(animation_name):
	if animation_name.begins_with("stand")\
		or animation_name.begins_with("move")\
		or animation_name.begins_with("attack"):
		$AnimatedSprite.play(animation_name + "_%d" % logicRoot.face_direction)
	else:
		$AnimatedSprite.play(animation_name)

func stop_animation():
	$AnimatedSprite.stop()

func get_playing_animation():
	return $AnimatedSprite.animation

func is_playing():
	return $AnimatedSprite.is_playing()

func get_muzzle(index = null):
	if index == null:
		return get_node("Muzzles/Muzzle_%d" % logicRoot.face_direction)
	else:
		return get_node("Muzzles/Muzzle_%d" % index)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("attack"):
		# 如果是攻击动画播放完成
		if logicRoot.stand_after_attack:
			play_animation("stand")
		else:
			stop_animation()
	elif $AnimatedSprite.animation.begins_with("death"):
		# 如果是死亡动画播放完成
		logicRoot.dead()
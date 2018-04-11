extends "res://scripts/Actor.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var logicRoot = $".."

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# 事件注册
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_AnimatedSprite_animation_finished():
	if logicRoot.stand_after_attack:
		play_animation("stand")
	else:
		stop_animation()
	pass # replace with function body

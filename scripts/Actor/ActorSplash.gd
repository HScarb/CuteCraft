# ActorSplash.gd
# 鼠标泼溅图演算体
extends "res://scripts/Actor.gd"

func _ready():
	set_process(true)
	pass

func _process(delta):
	$Sprite.set_rotation($Sprite.get_rotation() + 0.1)
	pass

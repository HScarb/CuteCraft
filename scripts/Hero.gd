# Hero.gd
# 主角单位
# Scarb
# 2018/04/03
extends "res://scripts/Unit.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# override
func get_is_attacking():
	if is_dead:
		return false
	pass

# override
func get_is_moving():
	if is_dead:
		return false

# override
func get_is_idling():
	if is_dead:
		return false
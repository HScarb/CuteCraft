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

# override 攻击状态开启条件
func get_on_attack_condi():
	if is_dead:
		return false
	return Input.is_action_pressed("ui_attack")

# virtual 攻击状态结束条件
func get_on_attack_end_condi():
	if is_dead:
		return false
	var ret = (not Input.is_action_pressed("ui_attack") and (not $AnimatedSprite.is_playing()))
	return ret

# virtual 移动状态开启条件
func get_on_move_condi():
	if is_dead or is_attacking:
		return false
	var ret = false
	if Input.is_action_pressed("ui_up")\
			or Input.is_action_pressed("ui_down")\
			or Input.is_action_pressed("ui_left")\
			or Input.is_action_pressed("ui_right"):
			ret = true
	return ret

# virtual 移动状态结束条件
func get_on_move_end_condi():
	if is_dead:
		return false
	var ret = true
	if Input.is_action_pressed("ui_up")\
		or Input.is_action_pressed("ui_down")\
		or Input.is_action_pressed("ui_left")\
		or Input.is_action_pressed("ui_right"):
		ret = false
	print("on_move_end_condi: ", ret)
	return ret

# virtual 闲置状态开启条件
func get_on_idle_condi():
	if is_dead:
		return false

# virtual 闲置状态结束条件
func get_on_idle_end_condi():
	return false

# virtual 死亡状态开启条件
func get_on_die_condi():
	return false
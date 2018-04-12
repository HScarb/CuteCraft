# Hero.gd
# 主角单位
# Scarb
# 2018/04/03
extends "res://scripts/Unit.gd"

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# override 攻击状态开启条件
func get_on_attack_condi():
	if is_dead:
		return false
	var ret = Input.is_action_pressed("ui_attack")\
			and get_attack_time() <= 0
	return ret

# virtual 攻击状态结束条件
func get_on_attack_end_condi():
	if is_dead:
		return false
	var ret = false
	if self.stand_after_attack:
		# 松开攻击按键以及没有正在播放攻击动画
		ret = (not Input.is_action_pressed("ui_attack"))\
				and (not self.unit_actor.get_playing_animation())
	else:
		# 松开攻击按键以及没有正在播放动画
		ret = (not Input.is_action_pressed("ui_attack"))\
				and (not self.unit_actor.is_playing())
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
	# return life <= 0
	return Input.is_action_pressed("ui_die")
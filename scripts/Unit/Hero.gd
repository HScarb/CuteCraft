# Hero.gd
# 主角单位
# Scarb
# 2018/04/03
extends "res://scripts/Unit/Unit.gd"

#########################
# override 攻击状态开启条件
func get_on_attack_condi():
	if is_dead:
		return false
	if self.weapon == null:
		return false
	var ret = Input.is_action_pressed("ui_attack")\
			and self.weapon.get_can_fire()
	return ret

# virtual 攻击状态结束条件
func get_on_attack_end_condi():
	if is_dead:
		return false
	var ret = false
	if self.stand_after_attack:
		# 松开攻击按键以及没有正在播放攻击动画
		ret = (not Input.is_action_pressed("ui_attack"))\
				and (not self.model.get_playing_animation().begins_with("attack"))
	else:
		# 松开攻击按键以及没有正在播放动画
		ret = (not Input.is_action_pressed("ui_attack"))\
				and (not self.model.is_playing())
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
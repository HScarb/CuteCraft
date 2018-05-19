extends "res://scripts/Effect/EffectTreeNode.gd"

export(float) var period = 1.0									# 周期
export(String) var weapon_name = "Unknow Weapon"				# 武器名称
export(float) var shoot_range = -1								# 武器射程，<0时为近战
export(int) var damage_frame = 0								# 造成伤害的攻击动画帧
export(int) var backswing = 0									# 攻击动画后摇帧数 
export(PackedScene) var effect_scene = null						# 效果
export(int) var muzzle_index = 0								# 武器所占用的炮口编号(一般单位模型只有1个炮口，为0号)

export var can_fire = true setget set_can_fire, get_can_fire	# 武器是否可以攻击

onready var logicRoot = $"../.."

signal can_fire_again											# 可以再次开火

func set_can_fire(val):
	can_fire = val
	if val:
		emit_signal("can_fire_again")

func get_can_fire():
	return can_fire

func _ready():
	# 刷新目标数据
	# self.refresh_target_data()
	# 初始化攻击计时器
	$AttackIntervalTimer.wait_time = period
	$AttackIntervalTimer.connect("timeout", self, "set_can_fire", [true])

# 每次攻击都刷新目标数据
func refresh_target_data():
	# 初始化目标数据
	self.origin_unit = logicRoot
	self.origin_point = logicRoot.position
	self.source_unit = logicRoot
	self.source_point = get_muzzle().position + logicRoot.position
	self.caster_unit = logicRoot
	self.caster_point = logicRoot.position
	self.target_point = self.calc_target_point()
	self.target_unit = []
	print("source_point: ", source_point)
	print("unit_point: ", caster_point)

func fire():
	if not can_fire:
		return
	set_can_fire(false)
	# 刷新目标数据
	refresh_target_data()
	# 重启武器冷却计时器
	# 	先更新武器冷却时间
	refresh_attack_period()
	$AttackIntervalTimer.start()
	# 发送武器开启信号
	SignalManager.emit_signal("weapon_start", self)
	# 运行效果
	if self.effect_scene == null:
		return
	# 	等待模型发来的信号
	# 	等到真正攻击帧时才运行效果
	yield(logicRoot.model, "reach_damage_frame")
	var effect = effect_scene.instance()
	if effect != null:
		trans_target_data(effect)
		effect.run()

# 刷新武器的攻击间隔(会将单位的攻击速度加成属性考虑在内)
func refresh_attack_period():
	$AttackIntervalTimer.wait_time = period / logicRoot.get_attr_value("attack_speed_multi")

# 向子效果传递目标数据
func trans_target_data(sub_effect):
	.trans_target_data(sub_effect)
	# 效果树源头为武器自身，没有父节点
	sub_effect.effect_origin = self
	sub_effect.parent_effect = null
	self.children_effect.append(sub_effect)

# 获取攻击间隔计时器剩下的时间
func get_attack_time():
	return $AttackIntervalTimer.time_left

# 获取武器射击向量
func get_shoot_vector():
	var rad = logicRoot.face_angle
	var shoot_vector = Vector2(cos(rad) * shoot_range, sin(rad) * shoot_range)
	shoot_vector = Global.cart_2_iso(shoot_vector)
	return shoot_vector

# 计算目标点位置
# Muzzle点位置+射程
# return: [Vector2]
func calc_target_point():
	var target_pos = null
	# 如果不是近战武器
	if self.shoot_range > 0:
		# 计算目标点
		var muzzle_pos = get_muzzle().position
		target_pos = muzzle_pos + logicRoot.position
		# 根据单位的朝向和武器射程计算出目标点
		# 单位的朝向转化成弧度
		var shoot_vector = get_shoot_vector()
		target_pos = target_pos + shoot_vector
	else:
		# *** 计算近战武器目标点
		target_pos = logicRoot.position
	return target_pos

# 根据武器的炮孔编号获取炮口
func get_muzzle():
	return logicRoot.model.get_muzzle_by_index(muzzle_index)

func get_shoot_range():
	return shoot_range
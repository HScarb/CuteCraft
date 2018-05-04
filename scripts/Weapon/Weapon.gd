extends Node

export(float) var period = 1.0									# 周期
export(String) var weapon_name = "Unknow Weapon"				# 武器名称
export(float) var shoot_range = -1								# 武器射程，<0时为近战
export(int) var damage_frame = 0								# 造成伤害的攻击动画帧
export(int) var backswing = 0									# 攻击动画后摇帧数 
export(PackedScene) var effect_scene = null						# 效果

export var can_fire = true setget set_can_fire, get_can_fire	# 武器是否可以攻击

onready var logicRoot = $".."

# 目标数据
var origin_point = null			# 起源点
var origin_unit = null			# 起源单位
var source_point = null			# 源点
var source_unit = null			# 源单位
var caster_point = null			# 施法者点
var caster_unit = null			# 施法者
var target_point = null			# 目标点
var target_unit = []			# 目标单位

var effect = null

signal can_fire_again											# 可以再次开火

func set_can_fire(val):
	can_fire = val
	if val:
		emit_signal("can_fire_again")

func get_can_fire():
	return can_fire

func _init():
	origin_point = null			# 起源点
	origin_unit = null			# 起源单位
	source_point = null			# 源点
	source_unit = null			# 源单位
	caster_point = null			# 施法者点
	caster_unit = null			# 施法者
	target_point = null			# 目标点
	target_unit = []			# 目标单位

func _ready():
	# 刷新目标数据
	self.refresh_target_data()
	# 初始化攻击计时器
	$AttackIntervalTimer.wait_time = period
	$AttackIntervalTimer.connect("timeout", self, "set_can_fire", [true])
	# 创建效果实体
	if effect_scene != null:
		effect = effect_scene.instance()
	pass

# 每次攻击都刷新目标数据
func refresh_target_data():
	# 初始化目标数据
	self.origin_point = logicRoot
	self.origin_point = logicRoot.position
	self.source_unit = logicRoot
	self.source_point = logicRoot.position
	self.caster_unit = logicRoot
	self.caster_point = logicRoot.position
	self.target_point = self.calc_target_point()
	self.target_unit = []

func fire():
	if not can_fire:
		return
	set_can_fire(false)
	# 刷新目标数据
	self.refresh_target_data()
	# 重启武器冷却计时器
	$AttackIntervalTimer.start()
	# 发送武器开启信号
	SignalManager.emit_signal("weapon_start", self)
	if effect != null:
		trans_target_data(effect)
		effect.run()

# 向子效果传递目标数据
func trans_target_data(effect):
	# 先传递效果树数据
	effect.effect_origin = self
	effect.parent_effect = null
	# 传递目标数据
	effect.origin_unit = self.origin_unit							# or null
	effect.origin_point = self.origin_point
	effect.source_unit = self.source_unit
	effect.source_point = self.source_point
	effect.caster_unit = self.caster_unit
	effect.caster_point = self.caster_point
	effect.target_point = self.target_point
	effect.target_unit = self.target_unit

# 获取攻击间隔计时器剩下的时间
func get_attack_time():
	return $AttackIntervalTimer.time_left

# 计算目标点位置
# return: [Vector2]
func calc_target_point():
	var target_pos = null
	# 如果不是近战武器
	if self.shoot_range > 0:
		# 计算目标点
		# 首先将单位点转换为平面坐标
		var plane_pos = Global.iso_2_plane(logicRoot.position)
		target_pos = plane_pos
		# 根据单位的朝向和武器射程计算出目标点
		# 单位的朝向转化成弧度
		var rad = deg2rad(Global.deg_2_godot(logicRoot.face_angle))
		target_pos.y += sin(rad) * self.shoot_range
		target_pos.x += cos(rad) * self.shoot_range
		# 将平面坐标转换为等视角坐标
		target_pos = Global.plane_2_iso(target_pos)
	else:
		# *** 计算近战武器目标点
		target_pos = logicRoot.position
	return target_pos

# 根据目标数据的类型获取该效果所带具体的目标数据点
func get_pos_by_target_data_type(target_data_type):
	match target_data_type:
		Global.TARGET_DATA.origin_point:
			return self.origin_point
		Global.TARGET_DATA.origin_unit:
			return self.origin_unit.position
		Global.TARGET_DATA.source_point:
			return self.source_point
		Global.TARGET_DATA.source_unit:
			return self.source_unit.position
		Global.TARGET_DATA.caster_point:
			return self.caster_point
		Global.TARGET_DATA.caster_unit:
			return self.caster_unit.position
		Global.TARGET_DATA.target_point:
			return self.target_point
		Global.TARGET_DATA.target_unit:
			return self.target_unit.position
		_:
			return null

# 根据目标数据的类型获取该效果所带的具体目标单位
func get_unit_by_target_data_type(target_data_type):
	match target_data_type:
		Global.TARGET_DATA.origin_point:
			return null
		Global.TARGET_DATA.origin_unit:
			return self.origin_unit
		Global.TARGET_DATA.source_point:
			return null
		Global.TARGET_DATA.source_unit:
			return self.source_unit
		Global.TARGET_DATA.caster_point:
			return null
		Global.TARGET_DATA.caster_unit:
			return self.caster_unit
		Global.TARGET_DATA.target_point:
			return null
		Global.TARGET_DATA.target_unit:
			# targt_unit为list
			return self.target_unit[0]
		_:
			return null
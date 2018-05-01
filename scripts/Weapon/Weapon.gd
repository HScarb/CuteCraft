extends Node

export(float) var period = 1.0									# 周期
export(String) var weapon_name = "Unknow Weapon"				# 武器名称
export(float) var weapon_range = -1								# 武器射程，<0时为近战
export(int) var damage_frame = 0								# 造成伤害的攻击动画帧
export(int) var backswing = 0									# 攻击动画后摇帧数 
export(PackedScene) var effect_scene = null						# 效果

export var can_fire = true setget set_can_fire, get_can_fire	# 武器是否可以攻击

onready var logicRoot = $".."

var effect = null

signal can_fire_again											# 可以再次开火

func set_can_fire(val):
	can_fire = val
	if val:
		emit_signal("can_fire_again")

func get_can_fire():
	return can_fire

func _ready():
	$AttackIntervalTimer.wait_time = period
	$AttackIntervalTimer.connect("timeout", self, "set_can_fire", [true])
	# 创建效果实体
	if effect_scene != null:
		effect = effect_scene.instance()
	pass

func fire():
	if not can_fire:
		return
	set_can_fire(false)
	$AttackIntervalTimer.start()
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
	effect.origin_unit = logicRoot							# or null
	effect.origin_point = logicRoot.position
	effect.source_unit = logicRoot
	effect.source_point = logicRoot.position
	effect.caster_unit = logicRoot
	effect.caster_point = logicRoot.position
	effect.target_unit = null
	# 	计算目标点
	effect.target_point = null
	var target_pos = null
	# 如果不是近战武器
	if self.weapon_range > 0:
		# 计算目标点
		# 首先将单位点转换为平面坐标
		var plane_pos = Global.iso_2_plane(logicRoot.position)
		target_pos = plane_pos
		# 根据单位的朝向和武器射程计算出目标点
		# 单位的朝向转化成弧度
		var rad = deg2rad(Global.deg_2_godot(logicRoot.face_angle))
		target_pos.y += sin(rad) * self.weapon_range
		target_pos.x += cos(rad) * self.weapon_range
		# 将平面坐标转换为等视角坐标
		target_pos = Global.plane_2_iso(target_pos)
		effect.target_point = target_pos
	print("Weapon target_pos: ", target_pos)

# 获取攻击间隔计时器剩下的时间
func get_attack_time():
	return $AttackIntervalTimer.time_left
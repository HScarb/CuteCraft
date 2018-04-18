extends Node

export(float) var period = 1.0							# 周期
export(String) var weapon_name = "Unknow Weapon"				# 武器名称
export(int) var damage_frame = 0						# 造成伤害的攻击动画帧
export(int) var backswing = 0							# 攻击动画后摇帧数 
export(PackedScene) var effect_scene = null					# 效果

export var can_fire = true setget set_can_fire, get_can_fire	# 武器是否可以攻击

onready var logicRoot = $".."

var effect = null

signal can_fire_again									# 可以再次开火

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
	if effect != null:
		effect.run()

func trans_target_data(effect):
	effect.origin_unit = logicRoot
	effect.origin_point = logicRoot.position
	

# 获取攻击间隔计时器剩下的时间
func get_attack_time():
	return $AttackIntervalTimer.time_left
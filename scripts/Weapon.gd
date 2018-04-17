extends Node

export(float) var period = 1.0							# 周期
export(String) var name = "Unknow Weapon"				# 武器名称
export(int) var damage_frame = 0						# 造成伤害的攻击动画帧
export(int) var backswing = 0							# 攻击动画后摇帧数 
export(PackedScene) var effect = null					# 效果

export var can_fire = true setget set_can_fire, get_can_fire	# 武器是否可以攻击

signal can_fire_again									# 可以再次开火

func set_can_fire(val):
	can_fire = val
	if val:
		emit_signal("can_fire_again")

func get_can_fire():
	return can_fire

func _ready():
	$AttackInvervalTimer.connect("timeout", self, "set_can_fire", [true])
	pass

func fire():
	if not can_fire:
		return
	if effect != null:
		effect.run()

		set_can_fire(false)
		$AttackInvervalTimer.start()
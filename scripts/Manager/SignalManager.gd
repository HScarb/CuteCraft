# SignalManager.gd
# 信号管理器，一般用来处理发送给演算体的信号
extends Node

var arr_actor = []

signal unit_birth(unit_type_name, unit)

func _ready():
	arr_actor.append(load("res://scenes/Actor/ActorUnitMarine.tscn").instance())
	for actor in arr_actor:
		actor.init()
	pass
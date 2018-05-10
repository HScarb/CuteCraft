extends Node2D

func _ready():
	MapManager.set_map(self)
	MapManager.set_layer_unit($walls)
	MapManager.set_layer_front($FrontLayer)
	# 将地图上已经摆放的单位添加到单位管理器中
	for unit in $walls.get_children():
		UnitManager.add_unit(unit)
		if unit.is_main_character:
			UnitManager.set_main_character(unit)
	
	# TEST:创建一个单位
	# UnitManager.create_unit("UnitMarine", Vector2(600, 200))
	pass
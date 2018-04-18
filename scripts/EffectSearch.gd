extends "res://scripts/Effect.gd"

export(int, "circle", "line") var search_type = 0	# 搜索类型: 圆或者直线
export(int) var arc = 360							# 搜索弧度
export(int) var facing_adjustment = 0				# 面向角度修正
export(float) var radius = 0  						# 搜索半径或者长度
export(int) var maximum_count = -1					# 最大搜索数量
export(PackedScene) var effect = null				# 执行子效果

var arr_search_unit = []							# 搜索效果搜索到的单位列表

func _init():
	pass

func run():
	if search_type == 0:
		# 如果是圆形范围搜索
		pass
	elif search_type == 1:
		# 如果是直线搜索
		pass

func trans_target_data(sub_effect):
	.trans_target_data(sub_effect)
	sub_effect.target_unit = self.arr_search_unit
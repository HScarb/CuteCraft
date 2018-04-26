# EffectSearch.gd
# 搜索区域效果
extends "res://scripts/Effect/Effect.gd"

export(int, "circle", "line") var search_type = 0	# 搜索类型: 圆或者直线
export(int) var arc = 360							# 搜索弧度 ***
export(int) var facing_adjustment = 0				# 面向角度修正 ***
export(float) var radius = 0  						# 搜索半径或者长度
export(int) var maximum_count = -1					# 最大搜索数量，-1为无限 ***
export(PackedScene) var effect = null				# 执行子效果
export(bool) var include_self = false				# 是否包含自身，默认不包含 

export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var launch_location = 3
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var impact_location = 6		# 搜索起始点，可以是点或单位，如果是单位那只能以某个具体单位为起点搜索

var arr_search_unit = []							# 搜索效果搜索到的单位列表

func _init():
	pass

func run():
	# 如果没有子效果，直接返回
	if effect == null:
		return
	# 搜索起始点
	var search_pos = get_pos_by_target_data_type(self.impact_location)
	var target_list = []
	if search_pos == null:
		print("[Error]EffectSearch.run: search_pos == null")
		return
	# 搜索单位
	if search_type == 0:
		# 如果是圆形范围搜索
		for unit in UnitManager.get_all_units():
			# 计算单位点(转化为平面坐标)与搜索起始点之间的距离
			var vector = Global.iso_2_plane(unit.position) - search_pos
			# 如果距离小于搜索半径，则加入目标列表
			if vector.length() <= radius:
				# 处理不包含自身
				if not include_self:
					# 如果是自身，不加入目标列表
					var self_unit = get_unit_by_target_data_type(self.launch_location)
					if self_unit == null:
						self_unit = self.source_unit
					if unit == self_unit:
						continue
				target_list.append(unit)
	elif search_type == 1:
		# 如果是直线搜索
		# 根据发射单位的朝向求出线段终点
		var launch_unit = get_unit_by_target_data_type(self.launch_location)
		if launch_unit == null:
			print("[Error]EffectSearch.run: launch_unit == null")
			return
		# 发射单位到目标点的弧度
		var rad = deg2rad(Global.deg_2_godot(launch_unit.face_angle + self.facing_adjustment))
		# 计算线段终点
		var end_pos = search_pos
		end_pos.x += self.radius * cos(rad)
		end_pos.y += self.radius * sin(rad)
		# 线段向量
		var vector = Vector2()
		vector.x = self.radius * cos(rad)
		vector.y = self.radius * sin(rad)
		# 与线段向量垂直的向量
		var vector_vertical = Vector2()
		vector_vertical.x = -vector.y
		vector_vertical.y = vector.x
		for unit in UnitManager.get_all_units():
			# 单位的平面位置
			var unit_plane_pos = Global.iso_2_plane(unit.position)
			# 单位与点的距离向量
			var dis = Vector2()
			dis.x = unit_plane_pos.x * vector_vertical.normalized()
			dis.y = unit_plane_pos.y * vector_vertical.normalized()
			# 将单位与点的距离和单位的半径比较
			if dis.length() <= unit.radius:
				# 处理不包含自身
				if not include_self:
					# 如果是自身，不加入目标列表
					var self_unit = get_unit_by_target_data_type(self.launch_location)
					if self_unit == null:
						self_unit = self.source_unit
					if unit == self_unit:
						continue
				target_list.append(unit)
	# 设置子效果的目标并且运行子效果
	print(self.name, " target_list: ", target_list)
	self.arr_search_unit = target_list
	var sub_effect = self.effect.instance()
	self.trans_target_data(sub_effect)
	sub_effect.run()

func trans_target_data(sub_effect):
	.trans_target_data(sub_effect)
	sub_effect.target_unit = self.arr_search_unit
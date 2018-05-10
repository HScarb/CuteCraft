# EffectTreeNode.gd
# 效果树节点基类
# 存放目标数据以及目标数据操作
extends Node

# 效果树数据
var effect_origin = null		# 效果树的起源(可以是效果、武器、技能等)
var parent_effect = null		# 该效果的父效果
var children_effect = []		# 该效果的子效果(list)

# 目标数据
var origin_point = null			# 起源点
var origin_unit = null			# 起源单位
var source_point = null			# 源点
var source_unit = null			# 源单位
var caster_point = null			# 施法者点
var caster_unit = null			# 施法者
var target_point = null			# 目标点
var target_unit = []			# 目标单位

func init_target_data():
	origin_point = null			# 起源点
	origin_unit = null			# 起源单位
	source_point = null			# 源点
	source_unit = null			# 源单位
	caster_point = null			# 施法者点
	caster_unit = null			# 施法者
	target_point = null			# 目标点
	target_unit = []			# 目标单位

	effect_origin = null		# 效果树的起源
	parent_effect = null		# 该效果的父效果
	children_effect = []		# 该效果的子效果

# virtual
# 传递目标数据
# 默认为：子效果的目标数据与父效果一致
func trans_target_data(sub_effect):
	if sub_effect == null:
		return
	# 传递效果树数据
	sub_effect.effect_origin = self.effect_origin
	sub_effect.parent_effect = self
	self.children_effect.append(sub_effect)

	# 传递目标数据
	sub_effect.origin_point = self.origin_point
	sub_effect.origin_unit = self.origin_unit
	sub_effect.source_point = self.source_point
	sub_effect.source_unit = self.source_unit
	sub_effect.caster_point = self.caster_point
	sub_effect.caster_unit = self.caster_unit
	sub_effect.target_point = self.target_point
	sub_effect.target_unit = self.target_unit

###### 根据目标数据类型返回目标数据函数 ######
# 根据目标数据类型获取数据(点或单位或list)
func get_data_by_target_data_type(target_data_type):
	match target_data_type:
		Global.TARGET_DATA.origin_point:
			return self.origin_point
		Global.TARGET_DATA.origin_unit:
			return self.origin_unit
		Global.TARGET_DATA.source_point:
			return self.source_point
		Global.TARGET_DATA.source_unit:
			return self.source_unit
		Global.TARGET_DATA.caster_point:
			return self.caster_point
		Global.TARGET_DATA.caster_unit:
			return self.caster_unit
		Global.TARGET_DATA.target_point:
			return self.target_point
		Global.TARGET_DATA.target_unit:
			return self.target_unit
		_:
			return null

# 根据目标数据的类型获取该效果所带具体的目标数据点
func get_pos_by_target_data_type(target_data_type):
	# 如果目标类型是单位，返回单位位置
	var unit = get_unit_by_target_data_type(target_data_type)
	if typeof(unit) == TYPE_ARRAY:
		var pos_list = []
		for u in unit:
			pos_list.append(u.position)
		return pos_list
	if unit != null:
		return unit.position
	# 如果目标类型是点，首先判断该目标点对应的单位是否为空
	# 不为空则返回单位位置，否则返回点位置
	match target_data_type:
		Global.TARGET_DATA.origin_point:
			if self.origin_unit != null:
				return self.origin_unit.position
			return self.origin_point
		Global.TARGET_DATA.source_point:
			if self.source_unit != null:
				return self.source_unit.position
			return self.source_point
		Global.TARGET_DATA.caster_point:
			if self.caster_unit != null:
				return self.caster_unit.position
			return self.caster_point
		Global.TARGET_DATA.target_point:
			return self.target_point
		_:
			return null

# 根据目标数据的类型获取该效果所带的具体目标单位
func get_unit_by_target_data_type(target_data_type):
	match target_data_type:
		Global.TARGET_DATA.origin_unit:
			return self.origin_unit
		Global.TARGET_DATA.source_unit:
			return self.source_unit
		Global.TARGET_DATA.caster_unit:
			return self.caster_unit
		Global.TARGET_DATA.target_unit:
			# targt_unit为list
			return self.target_unit
		_:
			return null

#########################################
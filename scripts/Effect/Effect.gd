extends Node

# 效果树数据
var effect_origin = null		# 效果树的起源
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


# 操作初始化
func _init():
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
	pass

# virtual
func run():
	print("run effect ", self.get_name())
	# 发送全局消息
	SignalManager.emit_signal("effect_start", self)

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
	pass

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

# 操作创建
func create():
	if (self.config.conditype != ""):
		var config = self.battlemanager.getopconditionconfig(self.config.conditype)
		var scriptname = "res://scripts/logic/battle/effect/condition/" + config.scriptname
		self.condition = load(scriptname).new()
		self.condition.init()
		self.condition.setoperator(self)
		self.condition.create()
	oncreate()

# 效果操作创建时触发,用于初始化特定效果内部的一些数据,虚函数调用
func oncreate():
	pass

# 操作执行
func dooperator():
	pass

# 操作销毁
func destroy():
	pass

# 操作条件判断
func condition():
	if (self.condition == null):
		return true
	return self.condition.issignal()

func getskilldoinfo():
	var event = self.effect.geteventargs()
	var skilldoinfo = {}
	if (event != null and event.has("fromunit") == true and event.has("targetid") == true):
		var fromunitid = event["fromunit"]
		var skillid = event["targetid"]
		if (fromunitid != null and skillid != null):
			var fromunit = self.unitmanager.getunit(fromunitid)
			if (fromunit != null):
				var skill = fromunit.getskill(skillid)
				if (skill != null):
					skilldoinfo = skill.getskilldoinfo()
	return skilldoinfo

# 操作目标获取
func getoptarget(targettype = ""):
	var event = self.effect.geteventargs()
	if (targettype == ""):
		targettype = self.config.target
	if (targettype == "单位组" or targettype == ""):		# 单位组
		return self.effect.gettarget()
	elif (targettype == "自身"):		# 自身
		return [self.effect.getfromunit()]
	elif (targettype == "攻击者"):		# 事件攻击者
		if (event != null and event.has("fromunit") == true):
			var fromunit = self.unitmanager.getunit(event["fromunit"])
			return [fromunit]
	elif (targettype == "被击者"):		# 事件被击者
		if (event != null and event.has("target") == true):
			var alltarget = []
			for target in event["target"]:
				var targetunit = self.unitmanager.getunit(target)
				alltarget.append(targetunit)
			return alltarget
	elif (targettype == "技能拥有者"):    # 技能拥有者
		var skill = self.effect.getskill()
		if skill == null:
			return []
		var owner = skill.getowner()
		if (owner != null):
			return [owner]
		return []
	elif (targettype == "Buff拥有者"):    # Buff拥有者
		var buff = self.effect.getbuff()
		if buff == null:
			return []
		return [buff.getowner()]
	elif (targettype == "识破单位组"):		# 技能识破单位组
		var skilldoinfo = getskilldoinfo()
		var alltarget = []
		if (skilldoinfo.has("shipo_unitlist")):
			for target in skilldoinfo["shipo_unitlist"]:
				var targetunit = self.unitmanager.getunit(target)
				alltarget.append(targetunit)
		return alltarget
	elif (targettype == "暴击单位组"):		# 技能暴击单位组
		var skilldoinfo = getskilldoinfo()
		var alltarget = []
		if (skilldoinfo.has("crit_unitlist")):
			for target in skilldoinfo["crit_unitlist"]:
				var targetunit = self.unitmanager.getunit(target)
				alltarget.append(targetunit)
		return alltarget
	elif (targettype == "闪避单位组"):		# 技能闪避单位组
		var skilldoinfo = getskilldoinfo()
		var alltarget = []
		if (skilldoinfo.has("dodge_unitlist")):
			for target in skilldoinfo["dodge_unitlist"]:
				var targetunit = self.unitmanager.getunit(target)
				alltarget.append(targetunit)
		return alltarget
	return []

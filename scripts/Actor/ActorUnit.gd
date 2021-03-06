# ActorUnit.gd
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null

# virtual
# 这里注册全局监听信号事件
func init():
	SignalManager.connect("unit_birth", self, "create_model")

# virtual
# 检测创建的单位类型是否为该演算体对应的类型，需要派生类重载
func check_type(type_name):
	if type_name.ends_with(check_type_name):
		return true
	return false

# 为父单位创建模型
# parent_unit:[Unit.gd]
func create_model(parent_unit):
	# 先验证单位类型名称
	if not check_name(parent_unit):
		return null
	# 根据模型参数创建模型
	if model == null:
		return null
	var new_model = self.model.instance()
	new_model.init_by_unit(parent_unit)
	return new_model

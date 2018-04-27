extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null

# virtual
# 这里注册全局监听信号事件
func init():
	pass

# virtual
# 检测创建的单位类型是否为该演算体对应的类型，需要派生类重载
func check_create_unit_type(unit_type_name):
	return true

# 创建模型
# parent_unit:[Unit.gd]
func create_model(unit_type_name, parent_unit):
	if not check_create_unit_type(unit_type_name):
		return null
	if self.model == null:
		return null
	var new_model = self.model.instance()
	new_model.init_by_unit(parent_unit)
	return new_model
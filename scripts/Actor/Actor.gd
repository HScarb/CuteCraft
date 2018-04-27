extends Node2D

# virtual
# 这里注册全局监听信号事件
func init():
	pass

# virtual
# 用于检测传入参数的类型是否是演算体对应的类型(根据名称判断)，需要派生类重载
func check_type(type_name):
	return true
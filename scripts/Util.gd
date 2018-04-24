# Util.gd
# 通用工具类

# 检查某个对象是否是某一接口的实例
#
# | 参数              | 默认值 | 类型         |  描述           |
# | -----------------|:-----:| ------------:| --------------:|
# | obj              | N/A   | Object       | 检查的对象       |
# | interface 		 | {}    | Object Resource Dicationay | 要匹配的接口对象实例 |
#
# * 返回值：boolean 检查是否通过
#
# **代码示例**
#
#```gdscript
# # 检查是否是 Node 的子类
# implements(obj, Node)
# # 检查是否是 res://abc.gd 的子类
# implements(obj, preload("res://abc.gd"))
# # 检查是否实现方法functionA、functionA并声明了signal1信号
# var interface = {
#       "methods": ["functionA", "functionA"],
#       "signals": ["signal1"]
# }
# implements(obj, interface)
#```
func implements(obj, interface = {}):
	if obj == null or interface == null:
		return false
	if not (typeof(obj) == TYPE_OBJECT):
		return false
	if typeof(interface) == TYPE_OBJECT and obj is interface:
		return true
	elif typeof(interface) == TYPE_DICTIONARY:
		var passed = true
		if interface.has("methods"):
			var methods = interface.methods
			if typeof(methods) == TYPE_ARRAY:
				for m in methods:
					if not obj.has_method(m):
						passed = false
						break
		if interface.has("signals"):
			var signals = interface.signals
			if typeof(signals) == TYPE_ARRAY:
				var objsignals =  obj.get_signal_list()
				var objsignalnames = []
				objsignalnames.resize(objsignals.size())
				for i in range(objsignals.size()):
					objsignalnames[i] = objsignals[i].name
				for s in signals:
					if not (s in objsignalnames):
						passed = false
						break
		return passed
	else:
		return false
# UnitAttr.gd
# 单位属性 类

var base_value = 0.0		# 基础属性值
var base_percent = 1.0		# 基础属性缩放系数
var fix_value = 0.0			# 附加值
var cur_value = 0.0			# 当前值
var max_value = 0.0			# 最大值

# 初始化
func init():
	self.base_value = 0.0
	self.base_percent = 1.0
	self.fix_value = 0.0
	self.cur_value = 0.0
	self.max_value = 0.0

func init_by_data(base, max):
    init()
    max_value = max
    modify(base)

# 改变属性,在诸如单位的初始化,buff的增加/删除的时候都需要调用到这个接口
func modify(base = 0.0, percent = 0.0, fix = 0.0, modify_max_value = false):
	self.base_value += base
	self.base_percent += percent
	self.fix_value += fix

	self.cur_value = float(self.base_value * self.base_percent) + float(self.fix_value)
	if modify_max_value:
		self.max_value = self.cur_value

# 获取当前值
func get_value():
	return get_cur_value()

# 获取当前值
func get_cur_value():
    return cur_value

# 设置当前值
func set_cur_value(value):
	self.cur_value = value
	if self.cur_value > self.max_value:
		self.cur_value = self.max_value

# 获取最大值
func get_max_value():
	return self.max_value

# 设置最大值
func set_max_value(value):
    self.max_value = value
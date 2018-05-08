# Behavior.gd
# 行为
extends Node

export(int, "positive", "negetive") var alignment = 0   # 对齐
export(float) var duration = 0                          # 持续时间
export(float) var period = 0                            # 周期
export(int) var period_count = -1                       # 周期计数
export(PackedScene) var icon = null                     # 图标
export(int) var maximum_stack_count = 1                 # 最大叠加层数
###### 效果 ######
export(PackedScene) var initial_effect = null           # 起始效果，在行为应用在单位时触发
export(PackedScene) var final_effect = null             # 行为移除时触发
export(PackedScene) var periodic_effect = null          # 每周期触发
export(PackedScene) var expire_effect = null            # 效果持续时间到期触发
export(PackedScene) var refresh_effect = null           # 效果被刷新触发
###### 修改单位 ######
export(Array) var testdic
###### 伤害响应 ######

var owner = null
var stack_count = 1
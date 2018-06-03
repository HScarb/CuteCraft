# Behavior.gd
# 行为
extends "res://scripts/Effect/EffectTreeNode.gd"

export(Texture) var icon = null                         # 图标
export(int, "positive", "negetive") var alignment = 0   # 对齐
export(float) var duration = 0                          # 持续时间
export(float) var period = 0                            # 周期
export(int) var period_count = -1                       # 周期计数，-1为无限循环
export(int) var maximum_stack_count = 1                 # 最大叠加层数
###### 效果 ######
export(PackedScene) var initial_effect = null           # 起始效果，在行为应用在单位时触发
export(PackedScene) var final_effect = null             # 行为移除时触发
export(PackedScene) var periodic_effect = null          # 每周期触发
export(PackedScene) var expire_effect = null            # 效果持续时间到期触发
export(PackedScene) var refresh_effect = null           # 效果被刷新触发
###### 修改单位 ######
# format: attr_name,percent,fix,modify_max_value(0 or 1)
export(PoolStringArray) var modification                # 单位修改表，用固定的格式表示修改
###### 伤害响应 ######

########################
var stack_count = 1                                     # 当前层数
var cur_period = 0                                      # 当前周期数

onready var logicRoot = $"../.."                        # 行为携带者(单位)

func _ready():
    init()

# 初始化数据和计时器等
func init():
    stack_count = 1
    cur_period = 0
    $TimerPeriodic.wait_time = period
    $TimerExpire.wait_time = duration

# override
# 向子效果传递目标数据
func trans_target_data(sub_effect):
    .trans_target_data(sub_effect)
    # 效果树源头为行为自身，没有父节点
    sub_effect.effect_origin = self
    sub_effect.parent_effect = null
    self.children_effect.append(sub_effect)
    pass

# 刷新目标数据
func refresh_target_data():
	# 初始化目标数据
	self.origin_unit = logicRoot
	self.origin_point = logicRoot.position
	self.source_unit = logicRoot
	self.source_point = logicRoot.position
	self.caster_unit = logicRoot
	self.caster_point = logicRoot.position
	self.target_unit = []
	self.target_point = logicRoot.position

# 应用修改单位
func apply_modification():
    for modify in modification:
        var arr_str = modify.split(",")
        var modify_max_value = true
        if arr_str[3].to_int() == 0:
            modify_max_value = false
        logicRoot.modify_attr(arr_str[0],0,arr_str[1].to_float(),arr_str[2].to_float(),modify_max_value)

# 回复修改单位
func reverse_modification():
    for modify in modification:
        var arr_str = modify.split(",")
        var modify_max_value = true
        if arr_str[3].to_int() == 0:
            modify_max_value = false
        logicRoot.modify_attr(arr_str[0],0,-arr_str[1].to_float(),-arr_str[2].to_float(),modify_max_value)
    pass

# 添加行为时操作
func on_add():
    refresh_target_data()
    if initial_effect != null:
        var effect_initial = initial_effect.instance()
        trans_target_data(effect_initial)
        effect_initial.run()
    # 应用修改单位
    apply_modification()
    # 发送全局消息
    print("behavior on")
    SignalManager.emit_signal("behavior_on", self)
    # 启动计时器
    $TimerPeriodic.start()
    $TimerExpire.start()

# 移除行为时操作
func on_remove():
    refresh_target_data()

    if final_effect != null:
        var effect_final = final_effect.instance()
        trans_target_data(effect_final)
        effect_final.run()
    # 回复修改单位
    reverse_modification()
    # 发送全局消息
    print("behavior off")
    SignalManager.emit_signal("behavior_off", self)
    # 移除自身
    queue_free()

# 周期性事件
func on_period():
    refresh_target_data()
    # 如果当前周期数超过周期数，暂停计时器并且返回
    cur_period = cur_period + 1
    if period > 0:
        if cur_period > period:
            $TimerPeriodic.stop()
            return
    if periodic_effect != null:
        var effect_periodic = periodic_effect.instance()
        trans_target_data(effect_periodic)
        effect_periodic.run()

# 行为到期操作
func on_expire():
    refresh_target_data()
    if expire_effect != null:
        var effect_expire = expire_effect.instance()
        trans_target_data(effect_expire)
        effect_expire.run()
    on_remove()

# 行为刷新操作
func on_refresh():
    refresh_target_data()
    # 添加层数
    if not stack_count >= maximum_stack_count:
        stack_count = stack_count + 1
    # 刷新时间
    $TimerExpire.set_wait_time(duration)
    $TimerExpire.start()
    # 运行刷新效果
    if refresh_effect != null:
        var effect_refresh = effect_refresh.instance()
        trans_target_data(effect_refresh)
        effect_refresh.run()

func _on_TimerExpire_timeout():
    on_expire()

func _on_TimerPeriodic_timeout():
    on_period()

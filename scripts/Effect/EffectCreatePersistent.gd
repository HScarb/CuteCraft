# EffectCreatePersistent.gd
# 创建持续效果
extends "res://scripts/Effect/Effect.gd"

export(int) var period_count = -1                       # 周期计数，-1为无限循环 ***
export(PoolRealArray) var period_durations              # 每一周期时间
export(PoolVector2Array) var periodic_offsets           # 周期偏移量，从offset_start_location开始到end_location结束
    # y轴为垂直偏移，起点为start_location，重点是end_location；x轴为水平偏移
export(float) var initial_delay = 0                     # 起始效果和开始计算周期延迟的时间 
export(float) var expire_delay = 0                      # 当所有周期耗尽时到效果耗尽延迟的时间
export(int, "location", "facing") var offset_direction = 0  # 根据朝向或者目标点来计算偏移
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var target_location = 6                                 # 目标点
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var offset_start_location = 3                           # 偏移起点
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var offset_end_location = 6                             # 偏移终点
export(int,"null", "origin_unit", "null", "source_unit", "null", "caster_unit", "null", "target_unit")\
var offset_facing_fallback = 3                          # 偏移朝向回退 若偏移开始点或结束点无效，则使用该单位的朝向作为偏移起点和方向
###### 效果 ######
export(PackedScene) var initial_effect = null           # 起始效果
export(PackedScene) var final_effect = null             # 终止效果
export(PackedScene) var expire_effect = null            # 耗尽效果
export(PackedScene) var periodic_effect = null          # 周期效果，每周期触发

var cur_period = 0                                      # 当前周期数
var offset_start_pos = null                             # 偏移开始点
var offset_end_pos = null                               # 偏移终点
var offset_facing_fallback_unit = null                  # 偏移朝向单位
var offset_vector_rad = null                            # 偏移量角度

func run():
    .run()
    refresh_target_data()
    UnitManager.add_child(self)
    # 开启初始延迟计时器或者直接运行初始函数
    if initial_delay > 0:
        $TimerInitialDelay.set_wait_time(initial_delay)
        $TimerInitialDelay.start()
    else:
        on_initial()

func refresh_target_data():
    offset_start_pos = get_pos_by_target_data_type(offset_start_location)
    offset_end_pos = get_pos_by_target_data_type(offset_start_location)
    offset_facing_fallback_unit = get_unit_by_target_data_type(offset_facing_fallback)

    if offset_direction == 0:
        offset_vector_rad = offset_end_pos.angle_to_point(offset_start_pos)
    elif offset_direction == 1:
        offset_start_pos = offset_facing_fallback_unit.position
        offset_vector_rad = offset_facing_fallback_unit.face_angle

# 起始效果
func on_initial():
    if initial_effect != null:
        var sub_effect = initial_effect.instance()
        trans_target_data(sub_effect)
        sub_effect.run()
    # 判断是否进入周期循环，如果周期列表为空则开启耗尽计时器；否则开启周期循环计时器，进入周期循环
    if period_durations == null:
        $TimerExpireDelay.set_wait_time(expire_delay)
        $TimerExpireDelay.start()
    else:
        $TimerPeriodic.set_wait_time(period_durations[cur_period])
        $TimerPeriodic.start()

# 周期到期事件
func on_period():
    # 如果没有周期性偏移，默认目标点为该效果目标点
    var target_pos = target_point
    # 进行周期偏移(如果有偏移量)，计算实际目标点
    if periodic_offsets != null and periodic_offsets.size() > cur_period and periodic_offsets[cur_period] != null:
        target_pos = calc_target_point(periodic_offsets[cur_period])
    # 运行周期效果
    var sub_effect = periodic_effect.instance()
    trans_target_data(sub_effect)
    sub_effect.target_point = target_pos
    sub_effect.run()
    # 增加当前周期计数
    cur_period += 1
    # 判断所有周期是否已经结束，结束则进入耗尽延迟；否则重新设定周期计时器
    if cur_period >= period_count:
        $TimerPeriodic.stop()
        $TimerExpireDelay.set_wait_time(expire_delay)
        $TimerExpireDelay.start()
    else:
        $TimerPeriodic.set_wait_time(period_durations[cur_period])
        $TimerPeriodic.start()

# 耗尽效果
func on_expire():
    if expire_effect != null:
        var sub_effect = expire_effect.instance()
        trans_target_data(sub_effect)
        sub_effect.run()
    on_final()

# 根据偏移开始点和结束点或偏移朝向回退计算
# offset: [Vector2]
# return: [Vector2] target_pos
func calc_target_point(offset):
    # 取源单位位置为默认目标位置
    var target_pos = offset_start_pos
    if offset == null:
        return target_pos
    var rad = 0
    # 如果根据偏移开始点和结束点计算目标点
    # 计算y轴偏移
    target_pos += Vector2(cos(offset_vector_rad) * offset.y, sin(offset_vector_rad) * offset.y)
    # 计算x轴偏移
    target_pos += Vector2(cos(offset_vector_rad+PI/2) * offset.x, sin(offset_vector_rad+PI/2) * offset.x)
    return target_pos

# 终止效果
func on_final():
    if final_effect != null:
        var sub_effect = final_effect.instance()
        trans_target_data(sub_effect)
        sub_effect.run()
    SignalManager.emit_signal("effect_stop", self)
    queue_free()

func _on_TimerInitialDelay_timeout():
	on_initial()

func _on_TimerExpireDelay_timeout():
	on_expire()

func _on_TimerPeriodic_timeout():
	on_period()

# Ability.gd
# 技能基类
extends "res://scripts/Effect/EffectTreeNode.gd"

export(String) var ability_name = null      # 技能名称
export(float) var cost_life = 0             # 生命消耗
export(float) var cost_enegy = 0            # 能量消耗
export(float) var time_start = 0            # 起始冷却
export(float) var time_use = 1              # 技能冷却时间
export(float) var time_prepare = 0          # 读条时间      ***

export(float) var can_fire = true setget set_can_fire, get_can_fire # 是否可以释放

onready var logicRoot = $"../.."

signal can_fire_again                        # 技能可以再次释放

func _ready():
    print("Abiltiy root: ", logicRoot)

func init():
    pass

func set_can_fire(val):
    can_fire = val
    if val:
        emit_signal("can_fire_again")

func get_can_fire():
    return can_fire

# 释放技能
func fire():
    if not can_fire:
        return
    # 消耗能量或者生命值
    if not logicRoot.cost_enegy(cost_enegy):
        return
    if not logicRoot.cost_life(cost_life):
        return
    if time_use > 0:
        # 如果有冷却时间
        if time_prepare > 0:
            # 如果有准备时间
            $TimerPrepare.set_wait_time(time_prepare)
            $TimerPrepare.start()
            SignalManager.emit_signal("ability_prepare_start", self)
        else:
            # 如果没有准备时间，直接释放技能
            # 开启技能冷却计时器
            set_can_fire(false)
            $TimerCoolDown.set_wait_time(time_use)
            $TimerCoolDown.start()
            run_effect()
    else:
        # 如果技能没有冷却时间
        if time_prepare > 0:
            # 如果有准备时间
            $TimerPrepare.set_wait_time(time_prepare)
            $TimerPrepare.start()
            SignalManager.emit_signal("ability_prepare_start", self)
        else:
            run_effect()

# virtual
# 运行技能效果
func run_effect():
    SignalManager.emit_signal("ability_start", self)
    # 刷新目标数据
    refresh_target_data()
    pass

# 技能添加到单位时调用
func on_add():
    # 开始起始冷却计时器
    if time_start > 0:
        $TimerStart.set_wait_time(time_start)
        $TimerStart.start()
        can_fire = false

# 技能从单位身上移除时调用
func on_remove():
    pass

# override
# 向子效果传递目标数据
func trans_target_data(sub_effect):
	.trans_target_data(sub_effect)
	# 效果树源头为武器自身，没有父节点
	sub_effect.effect_origin = self
	sub_effect.parent_effect = null
	self.children_effect.append(sub_effect)

# 每次攻击都刷新目标数据
func refresh_target_data():
	# 初始化目标数据
	self.origin_point = logicRoot
	self.origin_point = logicRoot.position
	self.source_unit = logicRoot
	self.source_point = logicRoot.position
	self.caster_unit = logicRoot
	self.caster_point = logicRoot.position
	self.target_unit = []
	self.target_point = calc_target_point()

# virtual
# 计算目标点位置
# return: [Vector2]
func calc_target_point():
	return logicRoot.position

# 初始冷却计时器到期事件
func _on_TimerStart_timeout():
	set_can_fire(true)

# 技能冷却计时器到期事件
func _on_TimerCoolDown_timeout():
    set_can_fire(true)

# 准备计时器到期事件
func _on_TimerPrepare_timeout():
	SignalManager.emit_signal("ability_prepare_stop", self)
	run_effect()

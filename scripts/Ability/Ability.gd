# Ability.gd
# 技能基类
extends "res://scripts/Effect/EffectTreeNode.gd"

export(String) var ability_name = null      # 技能名称
export(float) var cost_life = 0             # 生命消耗
export(float) var cost_enegy = 0            # 能量消耗
export(float) var time_start = 0            # 起始冷却
export(float) var time_use = 1              # 技能冷却时间
export(float) var time_prepare = 0          # 读条时间      ***

onready var logicRoot = $"../.."

func init():
    pass

func run():
    pass

func on_add():
    pass

func on_remove():
    pass

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
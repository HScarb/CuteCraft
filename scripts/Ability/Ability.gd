# Ability.gd
# 技能基类
extends Node

export(String) var ability_name = null      # 技能名称
export(float) var cost_life = 0             # 生命消耗
export(float) var cost_enegy = 0            # 能量消耗
export(float) var time_start = 0            # 起始冷却
export(float) var time_use = 1              # 技能冷却时间
export(float) var time_prepare = 0          # 读条时间      ***

# SignalManager.gd
# 信号管理器，一般用来处理发送给演算体的全局信号
extends Node

signal game_restart                         # 游戏开始消息

signal game_over                            # 主角死亡，游戏结束

signal unit_birth(unit)                     # 单位被创建

signal weapon_start(weapon)                 # 武器开火

signal ability_start(ability)               # 技能释放开始

signal ability_stop(ability)                # 技能释放完毕

signal ability_prepare_start(ability)       # 技能准备开始

signal ability_prepare_stop(ability)        # 技能准备结束

signal effect_start(effect)                 # 效果开启

signal effect_stop(effect)                  # 效果关闭

signal behavior_on(behavior)                # 行为开启

signal behavior_off(behavior)               # 行为关闭

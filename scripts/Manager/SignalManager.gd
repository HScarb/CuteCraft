# SignalManager.gd
# 信号管理器，一般用来处理发送给演算体的全局信号
extends Node

signal unit_birth(unit)                     # 单位被创建

signal weapon_start(weapon)                 # 武器开火

signal effect_start(effect)                 # 效果开启
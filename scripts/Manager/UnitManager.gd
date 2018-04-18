# UnitManager.gd
# 单位管理器，储存并管理地图中所有单位
extends Node

var arr_unit = []

func init():
    arr_unit.clear()

func create_unit():
    pass

func add_unit(unit):
    arr_unit.append(unit)
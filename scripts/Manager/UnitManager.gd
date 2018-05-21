# UnitManager.gd
# 单位管理器，储存并管理地图中所有单位
extends Node

var arr_unit = []
var arr_tracing = []                                # 地图上正在寻路的单位
var main_character = null setget set_main_character, get_main_character

func init():
    arr_unit.clear()
    arr_tracing.clear()

# 根据单位类型创建单位
# type:[PackedScene] 单位类型，为Scene
# pos:[Vector2] 创建单位的位置
func create_unit_by_type(type, pos):
    if type == null:
        return type
    var unit = type.instance()
    unit.set_position(pos)
    MapManager.get_layer_unit().add_child(unit)
    return unit

# 根据单位类型的名称创建单位
# type_name: [String]
# pos: [Vector2]
func create_unit(type_name, pos):
    if type_name == null:
        return null
    var unit_path = "res://scenes/Unit/%s.tscn" % type_name
    var unit_type = load(unit_path)
    return create_unit_by_type(unit_type, pos)

# 添加单位
func add_unit(unit):
    arr_unit.append(unit)

func remove_unit(unit):
    arr_unit.erase(unit)
    if unit == main_character:
        main_character = null

# 获取所有单位
func get_all_units():
    return self.arr_unit

func get_tracing_unit():
    return arr_tracing

# 添加寻路单位
func add_tracing_unit(unit):
    arr_tracing.append(unit)

# 移除寻路单位
func remove_tracing_unit(unit):
    arr_tracing.erase(unit)

# 设置主角单位
func set_main_character(unit):
    if unit != null:
        main_character = unit

# 获取主角单位
func get_main_character():
    return main_character
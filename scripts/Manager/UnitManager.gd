# UnitManager.gd
# 单位管理器，储存并管理地图中所有单位
extends Node

var class_unit = load("res://scripts/Unit/Unit.gd")

var arr_unit = []
var arr_tracing = []                                # 地图上正在寻路的单位
var main_character = null setget set_main_character, get_main_character
var arr_init_unit_info = []

func init():
    arr_unit.clear()
    arr_tracing.clear()

# 将节点的子单位全部加入到单位列表
func add_all_units_in_node(node):
    for unit in node.get_children():
        if unit is class_unit:
            add_unit(unit)
            if unit.is_main_character:
                set_main_character(unit)

# 根据地图上摆放的单位记录单位类型和位置
# info : {"pos": Vector2, "type": String}
func record_init_unit_info():
    for unit in arr_unit:
        if not unit.is_main_character:
            var info = {}
            info.pos = unit.position
            info.type = Global.get_node_name(unit)
            arr_init_unit_info.append(info)

# 摧毁所有单位，根据记录刷新怪物单位
func reset():
    for unit in arr_unit:
        unit.queue_free()
    init()
    for info in arr_init_unit_info:
        var unit = create_unit(info.type, info.pos)
        unit.player = 5    # *** 临时处理

# 根据单位类型创建单位
# type:[PackedScene] 单位类型，为Scene
# pos:[Vector2] 创建单位的位置
func create_unit_by_type(type, pos):
    if type == null:
        return type
    var unit = type.instance()
    unit.set_position(pos)
    MapManager.get_layer_unit().add_child(unit)
    add_unit(unit)
    return unit

# 根据单位类型的名称创建单位
# type_name: [String]
# pos: [Vector2]
func create_unit(type_name, pos):
    if type_name == null:
        return null
    var unit_path = Global.UNIT_DIR + "%s.tscn" % type_name
    var unit_type = load(unit_path)
    return create_unit_by_type(unit_type, pos)

# 添加单位
func add_unit(unit):
    arr_unit.append(unit)

# 移除单位
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
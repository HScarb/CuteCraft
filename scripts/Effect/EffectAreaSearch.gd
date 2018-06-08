# EffectAreaSearch.gd
# 用Area shape碰撞的形式搜索区域
extends "res://scripts/Effect/Effect.gd"

export(int) var arc = 360							# 搜索弧度 ***
export(int) var facing_adjustment = 0				# 面向角度修正 ***
export(float) var radius = 0  						# 搜索半径，搜索类型为直线时为直线宽度
export(int) var maximum_count = -1					# 最大搜索数量，-1为无限 ***
export(PackedScene) var effect = null				# 执行子效果
export(bool) var include_self = false				# 是否包含自身，默认不包含 

export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var launch_location = 3
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var impact_location = 6		# 搜索起始点，可以是点或单位，如果是单位那只能以某个具体单位为起点搜索

var arr_search_unit = []							# 搜索效果搜索到的单位列表

func init():
    arr_search_unit.clear()

# override
func trans_target_data(sub_effect):
    .trans_target_data(sub_effect)
    sub_effect.target_unit = arr_search_unit

func run():
    .run()
    if effect == null:
        return
    init()
    # 发射单位和搜索起点
    var launch_unit = get_unit_by_target_data_type(launch_location)
    var search_pos = get_pos_by_target_data_type(impact_location)
    # 创建一个搜索区域
    var area = Area2D.new()
    area.set_collision_layer_bit(0, false)
    area.set_collision_layer_bit(4, true)
    area.set_collision_mask_bit(0, false)
    area.set_collision_mask_bit(2, true)
    # 根据效果的半径范围,设置形状的大小
    var collision_shape = CollisionShape2D.new()
    var shape = CircleShape2D.new()
    shape.set_radius(radius)
    collision_shape.shape = shape
    area.add_child(collision_shape)
    MapManager.get_layer_unit().add_child(area)
    area.position = search_pos
    # 获取碰撞的形状，从而获取碰撞单位
    # area._physics_process()
    yield(area.get_tree(), "idle_frame")
    yield(area.get_tree(), "physics_frame")
    var overlapping_areas = area.get_overlapping_areas()
    print("Area searched area: ", overlapping_areas)
    for area in overlapping_areas:
        if area == launch_unit.get_node("BodyArea") and not include_self:
            continue
        if area.get_node("BodyShape").disabled:
            continue
        arr_search_unit.append(area.get_parent())
    print("arr_search_unit: ", arr_search_unit)
    # 运行子效果
    var sub_effect = effect.instance()
    #   传递目标数据，目标单位是搜索到的单位
    trans_target_data(sub_effect)
    sub_effect.run()
    area.queue_free()
    SignalManager.emit_signal("effect_stop", self)

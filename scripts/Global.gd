extends Node

# 游戏配置
const APP_NAME = "CuteCraft"
const VERSION = "0.0.0"
const DESIGN_SCREEN_SIZE = Vector2(1920, 1080)

# 全局常量
const MOTION_SPEED = 250

const X_ZOOM = 1
const Y_ZOOM = 0.5 

const Z_INDEX_UNIT = 2

var FACE_DIRECTION = {
    "east": 0,
    "south_east": 1,
    "south": 2,
    "south_west": 3,
    "west": 4,
    "north_west": 5,
    "north": 6,
    "north_east": 7
}

var TARGET_DATA = {
    "origin_point": 0,
    "origin_unit": 1,
    "source_point": 2,
    "source_unit": 3,
    "caster_point": 4,
    "caster_unit": 5,
    "target_point": 6,
    "target_unit": 7
}

var EFFECT_TREE_NODE = {
    "Missle": 1,
    "Caster": 2,
    "Target": 3,
    "CasterPos": 4,
    "TargetPos": 5,
    "Effect": 6
}

var PROPERTY = {
    0: "life",
    1: "enegy",
    
}

###### 全局路径常量 ######
const ACTOR_DIR = "res://scenes/Actor/Implement/"
const EFFECT_DIR = "res://scenes/Effect/Implement/"

###### 全局函数 ######
# 等视角坐标转换成笛卡尔坐标
func iso_2_cart(pos):
    return Vector2(pos.x, pos.y * 2)

# 笛卡尔坐标转换成等视角坐标
func cart_2_iso(pos):
    return Vector2(pos.x, pos.y / 2)

# 将角度转换成godot坐标系的角度
func deg_2_godot(degree):
    var deg = degree - 90
    if deg < 0:
        deg += 360
    return deg

# 将godot坐标系的角度转换成北面为x轴时的角度
func godot_2_deg(degree):
    var deg = degree + 90
    if deg >= 360:
        deg -= 360
    return deg

# 判断目标数据类型是否是单位
func is_target_data_unit(target_data_type):
    if target_data_type % 2 == 1:
        return true
    return false

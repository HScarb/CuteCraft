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
    "north": 0,
    "north_east": 1,
    "east": 2,
    "south_east": 3,
    "south": 4,
    "south_west": 5,
    "west": 6,
    "north_west": 7
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

###### 全局函数 ######
# 等视角坐标转换成平面坐标
func iso_2_plane(pos):
    return Vector2(pos.x, pos.y * 2)

# 平面坐标转换成等视角坐标
func plane_2_iso(pos):
    return Vector2(pos.x, pos.y / 2)
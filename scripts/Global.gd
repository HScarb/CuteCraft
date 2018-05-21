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
const PLAYER_SUM = 8

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

var ABILITY_SHORTCUT = [
    "Q", "W", "E", "R"
]

var T1_PLAYERS = [1,2,3,4]              # 队伍1中的玩家
var T2_PLAYERS = [5,6,7,8]              # 队伍2中的玩家

###### 全局路径常量 ######
const ACTOR_DIR = "res://scenes/Actor/Implement/"
const EFFECT_DIR = "res://scenes/Effect/Implement/"

###### Bit Mask ######
var MASK_UNIT_GROUND = 1
var MASK_GROUND = 2
var MASK_UNIT_BODY = 4
var MASK_MISSILE = 8

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

# 获取节点的文件名(没有后缀名)
func get_node_name(node):
    var file_name = node.get_filename()
    file_name = file_name.get_basename().get_file()
    return file_name

# 根据玩家编号获取玩家所在的队伍
func get_player_team(player):
    var team = -1
    if T1_PLAYERS.has(player):
        team = 1
    elif T2_PLAYERS.has(player):
        team = 2
    return team

# 判断两个玩家是否是同队
func is_ally(player1, player2):
    if player1 == null or player2 == null:
        return false
    var player1_team = get_player_team(player1)
    var player2_team = get_player_team(player2)
    if player1_team == player2_team:
        return true
    return false

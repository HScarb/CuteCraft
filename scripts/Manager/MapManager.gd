# MapManager.gd
# 地图管理器
extends Node

var node_map = null setget set_map, get_map                    # 地图节点
var layer_ground = null setget set_layer_ground, get_layer_ground  # 地面层
var layer_unit = null setget set_layer_unit, get_layer_unit    # 单位层节点
var layer_front = null setget set_layer_front, get_layer_front # 前景层，放特效等
var hero_spawn_point = null                 # [Vector2] 英雄出生点

func set_map(node):
    node_map = node

func get_map():
    return node_map

func set_layer_unit(node):
    layer_unit = node

func get_layer_unit():
    return layer_unit

func set_layer_front(node):
    layer_front = node

func get_layer_front():
    return layer_front

func set_hero_spawn_point(vec2):
    hero_spawn_point = vec2

func get_hero_spawn_point():
    return hero_spawn_point

func set_layer_ground(node):
    layer_ground = node

func get_layer_ground():
    return layer_ground
# MapManager.gd
# 地图管理器
extends Node

var node_map = null                     # 地图节点
var layer_unit = null                   # 单位层节点

func set_map(node):
    node_map = node

func get_map():
    return node_map

func set_layer_unit(node):
    layer_unit = node

func get_layer_unit():
    return layer_unit
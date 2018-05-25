# LayerManager.gd
# 层管理器
extends Node

var layer_hud = null setget set_layer_hud, get_layer_hud 
var layer_hero_select = null

func set_layer_hud(node):
    layer_hud = node

func get_layer_hud():
    return layer_hud

func set_layer_hero_select(node):
    layer_hero_select = node

func get_layer_hero_select():
    return layer_hero_select

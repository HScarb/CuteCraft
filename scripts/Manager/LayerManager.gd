# LayerManager.gd
# 层管理器
extends Node

var layer_hud = null setget set_layer_hud, get_layer_hud 
var layer_hero_select = null setget set_layer_hero_select, get_layer_hero_select
var layer_gameover = null setget set_layer_gameover, get_layer_gameover

func set_layer_hud(node):
    layer_hud = node

func get_layer_hud():
    return layer_hud

func set_layer_hero_select(node):
    layer_hero_select = node

func get_layer_hero_select():
    return layer_hero_select

func set_layer_gameover(node):
    layer_gameover = node

func get_layer_gameover():
    return layer_gameover

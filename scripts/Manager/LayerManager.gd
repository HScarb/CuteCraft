# LayerManager.gd
# 层管理器
extends Node

var hud = null setget set_hud, get_hud 
# var layer_hero_select = null setget set_layer_hero_select, get_layer_hero_select
# var layer_gameover = null setget set_layer_gameover, get_layer_gameover

func set_hud(node):
    hud = node

func get_hud():
    return hud

# func set_layer_hero_select(node):
#     layer_hero_select = node

# func get_layer_hero_select():
#     return layer_hero_select

# func set_layer_gameover(node):
#     layer_gameover = node

# func get_layer_gameover():
#     return layer_gameover

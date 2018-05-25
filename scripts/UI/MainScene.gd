# MainScene.gd
# 游戏主场景
extends Node

func _ready():
	LayerManager.set_layer_hud($HUD)
	LayerManager.set_layer_hero_select($HeroSelect)

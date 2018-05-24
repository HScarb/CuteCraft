# MainScene.gd
# 游戏主场景
extends Node

func _ready():
	$HUD.init()
	# 添加英雄选择界面
	MapManager.set_layer_hero_select($HeroSelect)


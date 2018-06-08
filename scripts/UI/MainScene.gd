# MainScene.gd
# 游戏主场景
extends Node

func _ready():
	init()

func init():
	LayerManager.set_hud($HUD)
	$HUD.init()
	SignalManager.connect("game_restart", self, "game_restart")

func game_restart():
	$HUD.layer_gameover.visible = false
	$HUD.layer_bottom.init()
	UnitManager.reset()
	$HUD.layer_hero_select.visible = true

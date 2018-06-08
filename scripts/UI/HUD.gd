# HUD.gd
# 前景ui层
extends CanvasLayer

var layer_gameover = null
var layer_bottom = null
var layer_hero_select = null

# 根据主角初始化界面
func init():
    layer_gameover = $GameOver
    layer_bottom = $BottomBar
    layer_hero_select = $HeroSelect
    # gameover层初始化，注册监听
    $GameOver.init()
    # 英雄选择初始化
    $HeroSelect.init()

func _process(delta):
    pass

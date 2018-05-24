# ButtonUnit.gd
extends TextureRect

var class_camera = preload("res://scenes/UI/Camera2D.tscn")

var button_unit = null              # [PackedScene]

func init_with_unit(unit):
    if unit == null:
        return
    button_unit = unit
    var unit_instance = unit.instance()
    var icon = unit_instance.icon
    $TextureButton.set_normal_texture(icon)

func _on_TextureButton_pressed():
    # 在英雄出生点创建英雄
    if button_unit != null:
        var hero = button_unit.instance()
        hero.set_position(MapManager.get_hero_spawn_point())
        MapManager.get_layer_unit().add_child(hero)
        # 设置主角
        UnitManager.set_main_character(hero)
        # 添加摄像头
        hero.add_child(class_camera.instance())
        # 关闭英雄选择界面
        MapManager.get_layer_hero_select().queue_free()

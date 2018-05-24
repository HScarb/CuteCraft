# HeroSelect.gd
# 英雄选择界面
extends CanvasLayer

var class_button_hero = preload("res://scenes/UI/ButtonUnit.tscn")

var arr_hero = []

func _ready():
    auto_add_heros()
    for hero in arr_hero:
        var button_hero = class_button_hero.instance()
        button_hero.init_with_unit(hero)
        $CenterContainer/GridContainer.add_child(button_hero)

func add_unit_by_name(unit_file_name):
    arr_hero.append(load("%s%s" % [Global.UNIT_DIR, unit_file_name]))

# 自动添加英雄
func auto_add_heros():
    var path = Global.UNIT_DIR
    var dir = Directory.new()
    if dir.open(path) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while(file_name != ""):
            print(file_name)
            if dir.current_is_dir():
                pass
            else:
                if file_name.begins_with("Hero"):
                    add_unit_by_name(file_name)
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")

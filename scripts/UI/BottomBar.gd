# BottomBar.gd
# 底部技能栏
extends Control

var scene_button_ability = load("res://scenes/UI/ButtonAbility.tscn")           # 技能按钮

var arr_button_ability = []                                                     # 技能按钮数组

func init():
    var ability_bar = $AbilityBar
    # 先清空原有技能按钮
    for button_ability in ability_bar.get_children():
        button_ability.queue_free()
    var main_character = UnitManager.get_main_character()
    if main_character != null:
        # 如果主角不为空
        # 初始化技能栏
        var ability_index = 0
        for ability in main_character.get_all_ability():
            # 如果有一个技能，则新建一个技能按钮并且初始化
            var new_button = scene_button_ability.instance()
            new_button.init_with_ability(ability, ability_index)
            ability_bar.add_child(new_button)
            ability_index += 1

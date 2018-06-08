# ButtonAbility.gd
# UI
# 技能按钮
extends TextureRect

var ability_shortcut = null                                    # 该技能按钮的快捷键
var node_ability = null                                        # 该按钮对应的技能
var enegy_cost = 0

func init():
    pass

# 使用技能初始化
func init_with_ability(ability, index):
    # 设置类变量
    node_ability = ability
    ability_shortcut = Global.ABILITY_SHORTCUT[index]
    enegy_cost = ability.cost_enegy
    # 设置显示内容
    $TextureButton.set_normal_texture(ability.icon)
    # 设置快捷键文本
    $LabelShortCut.set_text(ability_shortcut)
    # 设置能量消耗文本
    if enegy_cost > 0:
        $LabelEnegyCost.set_text(String(floor(enegy_cost)))
    else:
        $LabelEnegyCost.visible = false
    # 刷新冷却时间显示
    set_cooldown_text()

    set_process(true)
    pass

func set_cooldown_text():
    if UnitManager.get_main_character() == null:
        set_process(false)
    if node_ability == null:
        return
    var time_left = node_ability.get_node("TimerCoolDown").get_time_left()
    if time_left > 0:
        $LabelCoolDown.set_text(String(ceil(time_left)))
    else:
        $LabelCoolDown.set_text("")

func _process(delta):
    set_cooldown_text()
    pass
# AbilityEffectInstant.gd
# 效果-立即 类型的技能
extends "res://scripts/Ability/Ability.gd"

export(PackedScene) var effect = null

# override
func run_effect():
    # 发送全局消息
    .run_effect()
    if effect != null:
        var new_effect = effect.instance()
        trans_target_data(new_effect)
        # 即时效果的目标为单位自身
        new_effect.target_unit = [logicRoot]
        new_effect.run()

# ActorSpriteFramesTest.gd
# 帧动画演算体 - 测试，为陆战队员impact动画
extends "res://scripts/Actor/ActorSpriteFrames.gd"

# override
func init():
    SignalManager.connect("effect_start", self, "play_animation")
    pass

# override
func check_type(type_name):
    if type_name == "EffectSearchCircleTest":
        return true
    return false

# override
func play_animation(effect):
    var animated_sprite = .play_animation(effect)
    if animated_sprite == null:
        return
    # 设置大小
    animated_sprite.set_scale(Vector2(0.5, 0.5))

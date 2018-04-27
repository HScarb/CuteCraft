# ActorSpriteFramesTest.gd
# 帧动画演算体 - 测试
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
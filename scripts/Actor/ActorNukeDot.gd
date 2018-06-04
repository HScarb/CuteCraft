# ActorModel.gd
# 模型演算体
extends "res://scripts/Actor/ActorModel.gd"

func init():
    SignalManager.connect("effect_start", self, "play_model_animation")
    SignalManager.connect("effect_stop", self, "destroy_model")

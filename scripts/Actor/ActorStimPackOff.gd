# ActorStimPackOff.gd
# 兴奋剂行为开始 演算体
extends "res://scripts/Actor/ActorModel.gd"

func init():
    SignalManager.connect("behavior_off", self, "play_model_animation")

# ActorStimPackOn.gd
# 兴奋剂行为开始 演算体
extends "res://scripts/Actor/ActorModel.gd"

func init():
    print("connect behavior on")
    SignalManager.connect("behavior_on", self, "play_model_animation")
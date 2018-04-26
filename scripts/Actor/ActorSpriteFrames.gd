# ActorSpriteFrames.gd
# 序列帧动画演算体，播放一个序列帧动画
extends "res://scripts/Actor/Actor.gd"

func _ready():
    pass

func play_animation(animation_name = "default"):
    $AnimatedSprite.play(animation_name)


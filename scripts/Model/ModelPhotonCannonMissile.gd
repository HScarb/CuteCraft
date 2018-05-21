# ModelPhotonCannonMissile.gd
# 光子炮台发射物模型
extends "res://scripts/Model/Model.gd"

func modify_by_direction(direction):
	$AnimatedSprite.set_scale(Vector2(1, 1) * scale_factor)
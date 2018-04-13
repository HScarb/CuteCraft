extends "res://scripts/ActorAttack.gd"

func _ready():
	# 设置事件监听
	logicRoot.connect("attack_begin", self, "play_launch_animation", [Global.EFFECT_TREE_NODE.Caster])
	logicRoot.connect("damage_effect", self, "play_impact_animation", [Global.EFFECT_TREE_NODE.Target])
	pass

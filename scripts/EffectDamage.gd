extends "res://scripts/Effect.gd"

export(float)var amount = 0.0					# 伤害量

func run():
	for unit in target_unit:
		unit.take_damage(amount)
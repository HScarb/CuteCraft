# EffectDamage.gd
# 伤害效果
extends "res://scripts/Effect/Effect.gd"

export(float) var amount = 0.0					# 伤害量
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit") var launch_location = 3
export(int,"oritin_point", "origin_unit", "srouce_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit") var impact_location = 7

func run():
	if target_unit != null:
		for unit in target_unit:
			unit.take_damage(amount)
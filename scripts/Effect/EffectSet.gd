# EffectSet.gd
# 效果集合
extends "res://scripts/Effect/Effect.gd"
export(PackedScene) var effect_1 = null
export(PackedScene) var effect_2 = null
export(PackedScene) var effect_3 = null
export(PackedScene) var effect_4 = null
export(PackedScene) var effect_5 = null

var arr_effect = []

func run():
	.run()
	self._append_effect()
	for effect in arr_effect:
		var sub_effect = effect.instance()
		trans_target_data(sub_effect)
		sub_effect.run()
	pass

func _append_effect():
	if effect_1 != null:
		self.arr_effect.append(effect_1)
	if effect_2 != null:
		self.arr_effect.append(effect_2)
	if effect_3 != null:
		self.arr_effect.append(effect_3)
	if effect_4 != null:
		self.arr_effect.append(effect_4)
	if effect_5 != null:
		self.arr_effect.append(effect_5)

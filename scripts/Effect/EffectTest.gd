# EffectTest.gd
# 用来测试的效果，输出一些数据，作为效果树终点
extends "res://scripts/Effect/Effect.gd"

# override
func run():
	.run()
	print("###### Effect target data: #######")
	if origin_point != null:
		print("origin_point: ", origin_point.x, origin_point.y)
	if origin_unit != null:
		print("origin_unit: ", origin_unit, origin_unit.name)
	if source_point != null:
		print("source_point: ", source_point.x, source_point.y)
	if source_unit != null:
		print("source_unit: ", source_unit, source_unit.name)
	if caster_point != null:
		print("caster_point: ", caster_point.x, caster_point.y)
	if caster_unit != null:
		print("caster_unit: ", caster_unit, caster_unit.name)
	if target_point != null:
		print("target_point: ", target_point.x, target_point.y)
	if target_unit != null:
		print("target_unit: ", target_unit)
	print("##################################")
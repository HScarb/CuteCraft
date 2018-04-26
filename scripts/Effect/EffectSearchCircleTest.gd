extends "res://scripts/Effect/EffectSearch.gd"

func _draw():
	if self.search_type == 0:
		# 圆形搜索
		draw_circle(get_pos_by_target_data_type(self.impact_location), self.radius, Color(255,255,255))
	elif self.search_type == 1:
		# 直线搜索
		# draw_line(get_pos_by_target_data_type(self.impact_location), )
		pass
extends "res://scripts/Actor/Actor.gd"

export(PackedScene) var model = null

func init():
	pass

# virtual
func check_create_unit_type(unit_type_name):
	return true

# 创建模型
# parent_unit:[Unit.gd]
func create_model(unit_type_name, parent_unit):
	if not check_create_unit_type(unit_type_name):
		return null
	if self.model == null:
		return null
	var new_model = self.model.instance()
	new_model.init_by_unit(parent_unit)
	return new_model

# onready var logicRoot = $".."

# func _ready():
# 	logicRoot.connect("play_animation", self, "play_animation")
# 	logicRoot.connect("stop_animation", self, "stop_animation")
# 	logicRoot.connect("unit_ready", self, "refresh_status_bars")
# 	logicRoot.connect("life_enegy_change", self, "refresh_status_bars")
# 	pass

# func play_animation(animation_name):
# 	if animation_name.begins_with("stand")\
# 		or animation_name.begins_with("move")\
# 		or animation_name.begins_with("attack"):
# 		$AnimatedSprite.play(animation_name + "_%d" % logicRoot.face_direction)
# 	else:
# 		$AnimatedSprite.play(animation_name)

# func stop_animation():
# 	$AnimatedSprite.stop()

# func get_playing_animation():
# 	return $AnimatedSprite.animation

# func is_playing():
# 	return $AnimatedSprite.is_playing()

# # 刷新状态条
# func refresh_status_bars():
# 	print("refresh_status_bars")
# 	$LifeBar.set_value(logicRoot.life / logicRoot.life_max * 100)
# 	if logicRoot.enegy_max <= 0:
# 		$EnegyBar.set_visible(false)
# 	else:
# 		$EnegyBar.set_value(logicRoot.enegy / logicRoot.enegy_max * 100)
# 	pass

# func get_muzzle(index = null):
# 	if index == null:
# 		return get_node("Muzzles/Muzzle_%d" % logicRoot.face_direction)
# 	else:
# 		return get_node("Muzzles/Muzzle_%d" % index)

# func _on_AnimatedSprite_animation_finished():
# 	if $AnimatedSprite.animation.begins_with("attack"):
# 		# 如果是攻击动画播放完成
# 		if logicRoot.stand_after_attack:
# 			play_animation("stand")
# 		else:
# 			stop_animation()
# 	elif $AnimatedSprite.animation.begins_with("death"):
# 		# 如果是死亡动画播放完成
# 		logicRoot.dead()
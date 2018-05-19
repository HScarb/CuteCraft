# ModelUnit.gd
# 单位模型控制脚本
extends "res://scripts/Model/Model.gd"

signal reach_damage_frame

# 用Unit初始化ModelUnit
func init_by_unit(unit):
	.init_by_unit(unit)
	self.logicRoot.connect("unit_ready", self, "refresh_status_bars")
	self.logicRoot.connect("life_enegy_change", self, "refresh_status_bars")
	
	# 如果不是发射物，需要监听帧变动，用于武器前摇
	if not self.logicRoot is load("res://scripts/Unit/Missile.gd"):
		$AnimatedSprite.connect("frame_changed", self, "_on_AnimatedSprite_frame_changed")
		# 应用大小参数
		$AnimatedSprite.set_scale(Vector2(scale_factor, scale_factor))

# 单位定制版播放动画，会根据站立、移动、攻击动作播放响应朝向的动画
# func play_animation(animation_name = null):
# 	if animation_name == null:
# 		$AnimatedSprite.play("default")
# 		return
# 	var full_animation_name = animation_name						# 最终动画全名
# 	if animation_name.begins_with("stand")\
#         or animation_name.begins_with("move")\
# 		or animation_name.begins_with("attack"):
# 		full_animation_name = animation_name + "_%d" % logicRoot.face_direction
# 	.play_animation(full_animation_name)

# 刷新状态条
func refresh_status_bars():
	$LifeBar.set_value(logicRoot.get_attr_value("life") / logicRoot.get_attr_max("life") * 100)
	if logicRoot.enegy_max <= 0:
		$EnegyBar.set_visible(false)
	else:
		$EnegyBar.set_value(logicRoot.get_attr_value("enegy") / logicRoot.get_attr_max("enegy") * 100)
	pass

# 获取炮口位置
func get_muzzle(direction = null):
	var muzzle_count = 0
	for child in get_node("Muzzles").get_children():
		if child.get_name().begins_with("Muzzle"):
			muzzle_count = muzzle_count + 1
	if muzzle_count <= 0:
		return get_node("Muzzles")
	if direction == null:
		return get_node("Muzzles/Muzzle_%d" % logicRoot.face_direction)
	else:
		return get_node("Muzzles/Muzzle_%d" % direction)

# 获取炮口位置
func get_muzzles(direction = null):
	var muzzle_count = 0
	for child in get_node("Muzzles").get_children():
		if child.get_name().begins_with("Muzzle"):
			muzzle_count = muzzle_count + 1
	if muzzle_count <= 0:
		return get_node("Muzzles")
	var direction_index = null
	if direction == null:
		direction_index = logicRoot.face_direction
	else:
		direction_index = direction
	var arr_muzzle = []
	if has_node("Muzzles/Muzzle_%d" % direction_index):
		arr_muzzle.append(get_node("Muzzles/Muzzle_%d" % direction_index))
	if has_node("Muzzles/Muzzle_%dc" % direction_index):
		arr_muzzle.append(get_node("Muzzles/Muzzle_%dc" % direction_index))
	return arr_muzzle

# 获取模型被轰击时的轰击点位置
func get_impact_node():
	return get_node("AnimatedSprite")

# 动画播放结束调用
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("attack"):
		# 如果是攻击动画播放完成
		if logicRoot.stand_after_attack:
			play_animation("stand")
		else:
			stop_animation()
	elif $AnimatedSprite.animation.begins_with("death"):
		# 如果是死亡动画播放完成
		logicRoot.dead()

# 在动画的每一帧调用 攻击动画伤害帧
func _on_AnimatedSprite_frame_changed():
	if logicRoot.weapon == null:
		return
	if $AnimatedSprite.animation.begins_with("attack"):
		if $AnimatedSprite.frame == logicRoot.weapon.damage_frame:
			emit_signal("reach_damage_frame")
			
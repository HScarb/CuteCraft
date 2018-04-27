# Model.gd
# 单位模型控制脚本
extends Node2D

var logicRoot = null

# 用unit初始化
func init_by_unit(unit):
    unit.add_child(self)
    unit.model = self
    self.logicRoot = unit

    self.logicRoot.connect("play_animation", self, "play_animation")
    self.logicRoot.connect("stop_animation", self, "stop_animation")
    self.logicRoot.connect("unit_ready", self, "refresh_status_bars")
    self.logicRoot.connect("life_enegy_change", self, "refresh_status_bars")

func play_animation(animation_name):
    if animation_name.begins_with("stand")\
        or animation_name.begins_with("move")\
        or animation_name.begins_with("attack"):
        $AnimatedSprite.play(animation_name + "_%d" % logicRoot.face_direction)
    else:
        $AnimatedSprite.play(animation_name)

func stop_animation():
    $AnimatedSprite.stop()

func get_playing_animation():
    return $AnimatedSprite.animation

func is_playing():
    return $AnimatedSprite.is_playing()

# 刷新状态条
func refresh_status_bars():
	print("refresh_status_bars")
	$LifeBar.set_value(logicRoot.life / logicRoot.life_max * 100)
	if logicRoot.enegy_max <= 0:
		$EnegyBar.set_visible(false)
	else:
		$EnegyBar.set_value(logicRoot.enegy / logicRoot.enegy_max * 100)
	pass

func get_muzzle(index = null):
	if index == null:
		return get_node("Muzzles/Muzzle_%d" % logicRoot.face_direction)
	else:
		return get_node("Muzzles/Muzzle_%d" % index)

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
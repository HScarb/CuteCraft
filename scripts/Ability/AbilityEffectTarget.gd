# AbilityEffectTargt.gd
# 效果-目标 类型技能
extends "res://scripts/Ability/Ability.gd"

export(PackedScene) var effect
export(float) var shoot_range = 240              # 施法距离
export(String) var animation_name = "attack"    # 施法动画名称
export(int) var cast_frame = 0                  # 施法前摇帧数(如果有施法动画)
export(int) var muzzle_index = 0                # 炮口编号
    
# override
func run_effect():
    # 发送全局消息: ability_start
    .run_effect()
    if effect == null:
        return
    var new_effect = effect.instance()
    trans_target_data(new_effect)
    new_effect.run()

# 计算技能目标点位置
func calc_target_point():
	var target_pos = null
	if shoot_range > 0:
		var muzzle_pos = get_muzzle().position
		target_pos = muzzle_pos + logicRoot.position
		# 根据单位的朝向和武器射程计算出目标点
		# 单位的朝向转化成弧度
		var shoot_vector = get_shoot_vector()
		target_pos = target_pos + shoot_vector
	else:
		# *** 计算近战武器目标点
		target_pos = logicRoot.position
	return target_pos

# 获取武器射击向量
func get_shoot_vector():
	var rad = logicRoot.face_angle
	var shoot_vector = Vector2(cos(rad) * shoot_range, sin(rad) * shoot_range)
	shoot_vector = Global.cart_2_iso(shoot_vector)
	return shoot_vector

# 根据武器的炮孔编号获取炮口
func get_muzzle():
	return logicRoot.model.get_muzzle_by_index(muzzle_index)

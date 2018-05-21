# EffectLaunchRay.gd
# 发射射线
extends "res://scripts/Effect/Effect.gd"

export(PackedScene) var launch_effect = null            # 发射效果
export(PackedScene) var impact_effect = null            # 轰击效果
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var launch_location = 3                             # 发射位置，默认是源单位
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var impact_location = 6                             # 轰击位置，默认是目标点

func run(muzzle_index = 0):
    .run()
    # 判断发射单位是否是单位
    var launch_unit = get_data_by_target_data_type(launch_location)
    if not launch_unit is load("res://scripts/Unit/Unit.gd"):
        return
    # 运行发射效果
    var effect_launch = null
    if launch_effect != null:
        effect_launch = launch_effect.instance()
        # 给发射效果传递目标数据
        trans_target_data(effect_launch)
        effect_launch.target_unit.append(launch_unit)
        effect_launch.run()
    # 创建并激活raycast
    var raycast = RayCast2D.new()
    raycast.enabled = true
    raycast.add_exception(launch_unit.get_node("BodyArea"))             # 防止射线与自身碰撞
    raycast.set_collision_mask_bit(0, false)
    raycast.set_collision_mask_bit(2, true)
    # 获取武器或者技能的范围，调整raycast射向
    var origin = self.effect_origin
    var cast_vec = Vector2()
    cast_vec.x = origin.shoot_range * cos(launch_unit.face_angle)
    cast_vec.y = origin.shoot_range * sin(launch_unit.face_angle)
    cast_vec = Global.cart_2_iso(cast_vec)
    raycast.set_cast_to(cast_vec)
    # 添加到单位模型(从武器中获取单位模型的炮孔)
    effect_origin.get_muzzle().add_child(raycast)
    # 检测raycast碰撞
    var target = null
    var collision_pos = null
    raycast.force_raycast_update()
    if raycast.is_colliding():
        # 获取碰撞单位
        target = raycast.get_collider()     # BodyArea
        target = target.get_parent()        # Unit
        collision_pos = raycast.get_collision_point()
    # 运行轰击效果
    var effect_impact = null
    if impact_effect != null:
        effect_impact = impact_effect.instance()
        trans_target_data(effect_impact)
        if target != null and target != launch_unit:
            effect_impact.target_unit.append(target)
            effect_impact.target_point = collision_pos
        effect_impact.run()
    # 销毁raycast
   raycast.queue_free()

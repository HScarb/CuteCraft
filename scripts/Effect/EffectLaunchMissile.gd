# EffectLaunchMissile.gd
# 发射发射物效果
extends "res://scripts/Effect/Effect.gd"

# export(int,"creator") var ammo_owner = 0                # 发射物所有者
export(PackedScene) var ammo_unit = null                # 发射物单位
# 发射效果是飞弹发射时“对发射单位引发的效果”。对于发射效果属性的字效果而言，飞弹单位是其源单位，而发射飞弹的源单位是其目标单位。
export(PackedScene) var launch_effect = null            # 发射效果
# 轰击效果的作用是当飞弹命中目标以后，“对目标引发的效果”。因此，对于轰击效果属性的子效果而言，飞弹单位是其源单位，轰击的单位/点(通常也是发射飞弹效果的目标单位/点)是其目标单位/点。
export(PackedScene) var impact_effect = null            # 轰击效果
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var launch_location = 3                                 # 发射位置，默认是源单位
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit")\
var impact_location = 6                                 # 轰击位置，默认是目标点

func run():
    if ammo_unit == null:
        return
    .run()
    # 创建发射物实体
    var missile = ammo_unit.instance()
    MapManager.get_layer_unit().add_child(missile)
    # 设置发射物持续存在的时间
    add_timer_for_missile(missile)
    # 设置发射物属性
    var unit_launch = get_unit_by_target_data_type(launch_location)
    missile.player = unit_launch.player
    missile.parent_unit = unit_launch
    # 运行发射效果
    var effect_launch = null
    if launch_effect != null:
        effect_launch = launch_effect.instance()
        trans_target_data(effect_launch)
        # 发射效果是飞弹发射时“对发射飞弹的单位引发的效果”
        # 对于发射效果属性的字效果而言，飞弹单位是其源单位，而发射飞弹的源单位是其目标单位。
        effect_launch.source_unit = missile
        effect_launch.target_unit.append(self.source_unit)
        effect_launch.run()
    # 将轰击效果赋予发射物
    var effect_impact = null
    if impact_effect != null:
        effect_impact = impact_effect.instance()
        trans_target_data(effect_impact)
        # 轰击效果的作用是当飞弹命中目标以后，“对目标引发的效果”。
        # 对于轰击效果属性的子效果而言，飞弹单位是其源单位，轰击的单位/点(通常也是发射飞弹效果的目标单位/点)是其目标单位/点。
        effect_impact.source_unit = missile
        #   如果当前效果的轰击位置是单位
        if Global.is_target_data_unit(impact_location):
            effect_impact.target_unit.append(get_unit_by_target_data_type(impact_location))
        else:
            effect_impact.target_point = get_pos_by_target_data_type(impact_location)
        missile.effect_impact = effect_impact
    # 将发射物放置在正确位置(单位模型的炮口)
    var map_pos = effect_origin.get_muzzle().position + unit_launch.position
    missile.position = map_pos
    # 命令发射物移动
    #   根据单位当前的面向角度设置发射物的速度
    var motion = Vector2(cos(unit_launch.face_angle), sin(unit_launch.face_angle) * Global.Y_ZOOM)
    missile.motion = motion.normalized()
    missile.refresh_face_angel_by_motion()
    missile.modify_by_direction()

# 子弹到达攻击距离后如果没有遇到单位则原地爆炸
func add_timer_for_missile(missile):
    var weapon = effect_origin
    var shoot_vector = weapon.get_shoot_vector()
    var burst_time = shoot_vector.length() / missile.get_attr_value("speed")
    var impact_timer = Timer.new()
    impact_timer.set_wait_time(burst_time)
    impact_timer.set_one_shot(true)
    impact_timer.set_autostart(true)
    impact_timer.connect("timeout", missile, "impact", [null])
    missile.add_child(impact_timer)

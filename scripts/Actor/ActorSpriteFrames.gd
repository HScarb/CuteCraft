# ActorSpriteFrames.gd
# 序列帧动画演算体，播放一个序列帧动画
extends "res://scripts/Actor/Actor.gd"

export(SpriteFrames) var frames = null
export(int,"oritin_point", "origin_unit", "source_point", "source_unit", "caster_point", "caster_unit", "target_point", "target_unit", "effect_tree_descendent")\
var at_location = 6             # 序列帧动画创建的位置

# func init():
#     SignalManager.connect("effect_start", self, "play_animation")
#     pass

# 创建动画精灵并且播放
# effect: [Effect.gd]
# return: [AnimatedSprite]
func play_animation(effect):
    # 判空
    if effect == null:
        return
    # 检测类型
    if not check_name(effect):
        return
    # 创建动画
    var sprite_pos = effect.get_pos_by_target_data_type(at_location)
    if sprite_pos == null:
        print("[Error]ActorSpriteFrames.play_animation: sprite_pos == null")
        return
    # 在地图位置添加动画精灵
    var animated_sprite = create_animated_sprite(frames, MapManager.get_layer_unit())
    animated_sprite.set_position(sprite_pos)
    return animated_sprite

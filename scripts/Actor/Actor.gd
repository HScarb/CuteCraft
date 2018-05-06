# ActorAnimation
extends Node

# virtual
# 这里注册全局监听信号事件
func init():
	pass

# virtual
# 用于检测传入参数的类型是否是演算体对应的类型(根据名称判断)，需要派生类重载
func check_type(type_name):
	return false

# 创建序列帧动画
# sprite_frames: [SpriteFrames]
# parent_node: [Node2D]
# pos: [Vector2]
# return: [SpriteFrames]
func create_animated_sprite(sprite_frames, parent_node, pos = null):
	if sprite_frames == null or parent_node == null:
		return
	if pos == null:
		pos = Vector2(0 ,0)
	var animated_sprite = AnimatedSprite.new()
	animated_sprite.frames = sprite_frames
	animated_sprite.set_position(pos)
	animated_sprite.connect("tree_entered", animated_sprite, "play")
	animated_sprite.connect("animation_finished", animated_sprite, "queue_free")
	parent_node.add_child(animated_sprite)
	return animated_sprite
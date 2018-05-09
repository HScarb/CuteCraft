# ActorAnimation
extends Node

export(String) var check_type_name = null

# virtual
# 这里注册全局监听信号事件
func init():
	pass

# 使用check_type检查node的名称
func check_name(node, check_func = "check_type"):
	var file_name = Global.get_node_name(node)
	var ret = call(check_func, file_name)
	return ret

# virtual
# 用于检测传入参数的类型是否是演算体对应的类型(根据名称判断)，需要派生类重载
func check_type(type_name):
	if check_type_name != null:
		return type_name == check_type_name
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

# 创建序列帧动画
# model_scene: [PackedScene]
# parent_node: [Node2D]
# pos: [Vector2]
# return: [Model.gd]
func create_animated_model(model_scene, parent_node, pos = null):
	if model_scene == null or parent_node == null:
		return
	if pos == null:
		pos = Vector2(0, 0)
	# 创建新的模型
	var new_model = model_scene.instance()
	# 进入场景树后开始播放动画
	new_model.init()
	new_model.set_position(pos)
	# 添加到父节点
	parent_node.add_child(new_model)
	return new_model

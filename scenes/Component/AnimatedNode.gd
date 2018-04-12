# AnimatedNode.gd
# 高级一点的AnimatedSprite
extends AnimatedSprite

export(float) var speed = 1.0 setget _set_speed			# 播放速度
export(float) var offset = Vector2() setget _set_offset	# 偏移量
export(float) var scale = 1000.0 setget _set_scale		# 缩放千分比

var cur_loop = 0										# 当前第几次播放

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

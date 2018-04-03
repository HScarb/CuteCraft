extends KinematicBody2D

export(bool) var is_main_character = false

export(SpriteFrames) var sprite_frames = null		# 序列帧动画
export(float) var face_angle						# 面向角度
export(int,"north","north_east","east","south_east","south","south_west","west","north_west") var face_direction = 5		# 朝向
export(int) var life = 10							# 生命值
export(int) var life_max = 10						# 生命最大值
export(int) var enegy = 10							# 能量
export(int) var enegy_max = 10						# 能量最大值
export(float) var radius							# 内部半径
export(float) var speed = 3							# 移动速度
export(float) var acceleration = 0					# 加速度

var motion = Vector2()								# 真实移动向量
var is_dead = false									# 是否死亡
var is_moving = false								# 是否移动中
var is_attacking = false							# 是否攻击中
var is_idling = false								# 是否摸鱼中

func _ready():
	$AnimatedSprite.frames = sprite_frames
	pass

func _physics_process(delta):
	if not is_main_character:
		return

	if motion.x == 0 and motion.y < 0:
		face_direction = 0
	elif motion.x > 0 and motion.y < 0:
		face_direction = 1
	elif motion.x > 0 and motion.y == 0:
		face_direction = 2
	elif motion.x > 0 and motion.y > 0:
		face_direction = 3
	elif motion.x == 0 and motion.y > 0:
		face_direction = 4
	elif motion.x < 0 and motion.y > 0:
		face_direction = 5
	elif motion.x < 0 and motion.y == 0:
		face_direction = 6
	elif motion.x < 0 and motion.y < 0:
		face_direction = 7
	

	motion = Vector2()

# 获取武器的攻击间隔
func get_attack_interval():
	# 先简单处理
	return 1.0

# virtual
func get_is_attacking():
	if is_dead:
		return false
	pass

# virtual
func get_is_moving():
	if is_dead:
		return false

# virtual
func get_is_idling():
	if is_dead:
		return false
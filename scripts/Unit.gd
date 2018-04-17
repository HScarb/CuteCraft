extends KinematicBody2D

export(bool) var is_main_character = false

export(bool) var stand_after_attack = true			# 攻击之后是否进入站立动画
export(float) var face_angle						# 面向角度
export(int,"north","north_east","east","south_east","south","south_west","west","north_west") var face_direction = 5		# 朝向
export(int) var life = 10							# 生命值
export(int) var life_max = 10						# 生命最大值
export(int) var enegy = 10							# 能量
export(int) var enegy_max = 10						# 能量最大值
export(float) var radius = 10						# 内部半径
export(float) var speed = 3							# 移动速度
export(float) var acceleration = 0					# 加速度
export(NodePath) var unit_actor_path = null			# 单位演算体路径
export(NodePath) var weapon_path = null				# 武器路径

var motion = Vector2()								# 真实移动向量
var is_dead = false									# 是否死亡
var is_moving = false								# 是否移动中
var is_attacking = false							# 是否攻击中
var is_idling = false								# 是否摸鱼中
var attack_time = 0	setget set_attack_time, get_attack_time	# 一次攻击之后需要等待的时间，之后放到武器中
var unit_actor = null								# 单位演算体
var weapon = null									# 武器
const attack_interval = 1.0

signal play_animation(anim_name)
signal stop_animation
signal attack_begin

func _ready():
	# 设置单位演算体
	if unit_actor_path != null:
		self.unit_actor = get_node(unit_actor_path)
	# 设置武器
	if weapon_path != null:
		self.weapon = get_node(weapon_path)
	# 设置移动碰撞体大小
	var shape = $CollisionShape2D.get_shape()
	shape.set_radius(self.radius)
	shape.set_height(self.radius)
	pass

func _physics_process(delta):
	if attack_time > 0:
		attack_time -= delta
	else:
		attack_time = 0
	pass

# 获取武器的攻击间隔
func get_attack_interval():
	# 先简单处理
	return attack_interval

# 获取一次攻击之后等待的时间
func get_attack_time():
	# 先简单处理，之后放到武器中
	return attack_time

func set_attack_time(value):
	if value <= 0:
		attack_time = 0
	else:
		attack_time = value

# virtual 攻击状态开启条件
func get_on_attack_condi():
	if is_dead:
		return false
	pass

# virtual 攻击状态结束条件
func get_on_attack_end_condi():
	pass

# virtual 移动状态开启条件
func get_on_move_condi():
	if is_dead:
		return false

# virtual 移动状态结束条件
func get_on_move_end_condi():
	return false

# virtual 闲置状态开启条件
func get_on_idle_condi():
	if is_dead:
		return false

# virtual 闲置状态结束条件
func get_on_idle_end_condi():
	return false

# virtual 死亡状态开启条件
func get_on_die_condi():
	return false
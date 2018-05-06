# Unit.gd
# 单位
extends KinematicBody2D

export(bool) var is_main_character = false
export(bool) var stand_after_attack = true			# 攻击之后是否进入站立动画

export(int) var player = 1							# 隶属玩家
export(float) var face_angle = PI / 2				# 初始面向角度
export(int,"east","south_east","south","south_west","west","north_west","north","north_east") var face_direction = 2		# 朝向
export(int) var life = 10							# 生命值
export(int) var life_max = 10						# 生命最大值
export(int) var enegy = 10							# 能量
export(int) var enegy_max = 10						# 能量最大值
export(float) var radius = 10						# 内部半径
export(float) var speed = 3							# 移动速度
export(float) var acceleration = 0					# 加速度
export(NodePath) var weapon_path = null				# 武器路径

var motion = Vector2()								# 真实移动向量
var is_dead = false									# 是否死亡
var is_moving = false								# 是否移动中
var is_attacking = false							# 是否攻击中
var is_idling = false								# 是否摸鱼中
var weapon = null									# 武器
var model = null									# 单位模型(包含状态条等)

signal unit_ready
signal life_enegy_change							# 生命值或者能量值变化
signal play_animation(anim_name)
signal stop_animation
signal attack_begin

var class_hero = load("res://scripts/Unit/Hero.gd")

func _ready():
	# 设置武器
	if weapon_path != null:
		self.weapon = get_node(weapon_path)
	# 设置移动碰撞体大小
	var shape = CapsuleShape2D.new()
	shape.set_radius(self.radius)
	shape.set_height(self.radius)
	$GroundShape.set_shape(shape)
	# 发送全局演算体消息
	SignalManager.emit_signal("unit_birth", self)
	# 给Model发送消息
	self.emit_signal("unit_ready")
	pass

# func _physics_process(delta):
# 	# 单位根据面向角度调整朝向
# 	# refresh_face_direction()
# 	refresh_face_angel_by_motion()

# 根据motion(速度向量)来调整面向角度
func refresh_face_angel_by_motion():
	var plane_motion = Global.iso_2_plane(self.motion)
	var rad = plane_motion.angle()
	self.face_angle = rad

	_refresh_face_direction()
	pass

# 根据面向角度调整朝向
func _refresh_face_direction():
	if (self.face_angle <= PI / 8 and self.face_angle >= 0)\
		or (self.face_angle <= 0 and self.face_angle >= - PI / 8):
		self.face_direction = Global.FACE_DIRECTION.east
	elif self.face_angle >= PI / 8 and self.face_angle <= PI / 8 * 3:
		self.face_direction = Global.FACE_DIRECTION.south_east
	elif self.face_angle >= PI / 8 * 3 and self.face_angle <= PI / 8 * 5:
		self.face_direction = Global.FACE_DIRECTION.south
	elif self.face_angle >= PI / 8 * 5 and self.face_angle <= PI / 8 * 7:
		self.face_direction = Global.FACE_DIRECTION.south_west
	elif (self.face_angle >= PI / 8 * 7 and self.face_angle <= PI)\
		or (self.face_angle <= - PI / 8 * 7 and self.face_angle >= 0):
		self.face_direction = Global.FACE_DIRECTION.west
	elif self.face_angle <= - PI / 8 * 5 and self.face_angle >= - PI / 8 * 7:
		self.face_direction = Global.FACE_DIRECTION.north_west
	elif self.face_angle <= - PI / 8 * 3 and self.face_angle >= - PI / 8 * 5:
		self.face_direction = Global.FACE_DIRECTION.north
	elif self.face_angle <= - PI / 8 * 1 and self.face_angle >= - PI / 8 * 3:
		self.face_direction = Global.FACE_DIRECTION.north_east
	pass

func stand():
	# 播放站立动画
	play_stand_animation()

func move():
	# 播放移动动画
	play_move_animation()
	# 移动
	move_and_slide(self.motion)

func attack():
	if self.weapon == null:
		return
	if self.weapon.get_can_fire():
		# 播放攻击动画
		play_attack_animation()
		# 攻击开始信号
		self.emit_signal("attack_begin")
		# 武器攻击
		self.weapon.fire()

# 承受伤害
func take_damage(amount):
	life -= amount
	self.emit_signal("life_enegy_change")
	if life <= 0:
		die()

# 单位死亡调用
func die():
	self.is_dead = true
	pass

# 死亡动画播放完成调用
func dead():
	self.queue_free()

# 获取武器的攻击间隔
func get_attack_interval():
	return self.weapon.period

# 获取一次攻击之后等待的时间
func get_attack_time():
	return self.weapon.get_attack_time()

###### 播放动画 ######
# 播放站立动画
func play_stand_animation():
	emit_signal("play_animation", "stand")
	
# 播放移动动画
func play_move_animation():
	emit_signal("play_animation", "move")

# 播放攻击动画
func play_attack_animation():
	emit_signal("play_animation", "attack")

# 播放死亡动画
# 死亡动画规则:
# - 如果有4方向的死亡动画，根据单位的当前朝向播放
# - 否则随机播放一个死亡动画
func play_dead_animation():
	var dir = self.face_direction
	var frames = self.model.get_node("AnimatedSprite").get_sprite_frames()
	if frames.has_animation("death_0"):
		# 如果有4方向死亡动画
		match dir:
			0, 7:
				self.emit_signal("play_animation", "death_0")
			1, 2, 3:
				self.emit_signal("play_animation", "death_1")
			4, 5:
				self.emit_signal("play_animation", "death_2")
			6:
				self.emit_signal("play_animation", "death_3")
	else:
		# 如果没有，随机一个死亡动画
		randomize()
		self.is_dead = true
		# 	统计死亡动画个数
		var death_anim_num = 0
		while frames.has_animation("death%d" % death_anim_num):
			death_anim_num += 1
		var i = randi() % death_anim_num
		# 	随机播放死亡动画
		self.emit_signal("play_animation", "death%d" % i)

###### 状态切换条件 ######
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
	return self.is_dead
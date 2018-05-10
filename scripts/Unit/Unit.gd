# Unit.gd
# 单位
extends KinematicBody2D

export(bool) var is_main_character = false
export(bool) var stand_after_attack = true			# 攻击之后是否进入站立动画

export(int) var player = 1							# 隶属玩家
export(float) var face_angle = PI / 2				# 初始面向角度
export(int,"east","south_east","south","south_west","west","north_west","north","north_east") var face_direction = 2		# 朝向
export(float) var life = 10							# 生命值
export(float) var life_max = 10						# 生命最大值
export(float) var life_recover = 0					# 每秒生命回复 
export(float) var enegy = 10						# 能量
export(float) var enegy_max = 10					# 能量最大值
export(float) var enegy_recover = 0					# 每秒能量回复
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

var map_attr = {}									# 单位真正属性表

signal unit_ready
signal life_enegy_change							# 生命值或者能量值变化
signal play_animation(anim_name)
signal stop_animation
signal attack_begin

var class_hero = load("res://scripts/Unit/Hero.gd")
var class_attr = load("res://scripts/Unit/UnitAttr.gd")

func _init_attr_table():
	# 初始化属性表
	map_attr.clear()
	# 初始化添加属性
	_add_attr("life", life, life_max)
	_add_attr("life_recover", life_recover)
	_add_attr("enegy", enegy, enegy_max)
	_add_attr("enegy_recover", enegy_recover)
	_add_attr("speed", speed)
	_add_attr("acceleration", 0)
	_add_attr("attack_speed_multi", 1)
	_add_attr("damage", 0)

func _ready():
	print("unit_ready: ", self.name)
	_init_attr_table()
	# 发送全局演算体消息
	SignalManager.emit_signal("unit_birth", self)
	# 设置武器
	if weapon_path != null:
		self.weapon = get_node(weapon_path)
	# 设置技能
	for ability in $Abilities.get_children():
		ability.on_add()
	# 设置行为
	for behavior in $Behaviors.get_children():
		behavior.on_add()
	# 设置移动碰撞体大小
	var shape = CapsuleShape2D.new()
	shape.set_radius(self.radius)
	shape.set_height(self.radius)
	$GroundShape.set_shape(shape)
	$TimerRecover.start()
	# 给Model发送消息
	self.emit_signal("unit_ready")
	pass

###### 属性操作 ######
func _add_attr(attr_name, base, max_value = null):
	if max_value == null:
		max_value = base
	var attr = class_attr.new()
	attr.modify(base)
	map_attr[attr_name] = attr
	return attr

func modify_attr(attr_name, base = 0.0, percent = 0.0, fix = 0.0, modify_cur_value = true):
	map_attr[attr_name].modify(base, percent, fix, modify_cur_value)

func get_attr(attr_name):
	return map_attr[attr_name]

func get_attr_max(attr_name):
	return get_attr(attr_name).get_max_value()

func get_attr_value(attr_name):
	return get_attr(attr_name).get_value()
##################

# func _physics_process(delta):
# 	# 单位根据面向角度调整朝向
# 	# refresh_face_direction()
# 	refresh_face_angel_by_motion()

# 根据motion(速度向量)来调整面向角度
func refresh_face_angel_by_motion():
	var plane_motion = Global.iso_2_cart(self.motion)
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

# 每秒恢复生命和能量
func recover():
	if get_attr_value("life_recover") != 0:
		get_attr("life").set_cur_value(get_attr_value("life") + get_attr_value("life_recover"))
	if get_attr_value("enegy_recover") != 0:
		get_attr("enegy").set_cur_value(get_attr_value("enegy") + get_attr_value("enegy_recover"))
	self.emit_signal("life_enegy_change")

# 承受伤害
func take_damage(amount):
	# 减少生命
	var attr_life = get_attr("life")
	attr_life.set_cur_value(attr_life.get_value() - amount)
	# 发送消息
	self.emit_signal("life_enegy_change")
	if get_attr_value("life") <= 0:
		die()

# 消耗生命值(技能消耗，如果生命值过低则无法使用技能)
func cost_life(amount):
	if get_attr_value("life") < amount:
		return false
	# 减少生命值
	var attr_life = get_attr("life")
	attr_life.set_cur_value(attr_life.get_value() - amount)
	# 发送消息
	self.emit_signal("life_enegy_change")
	return true

# 消耗能量
func cost_enegy(amount):
	# 如果当前能量小于要消耗的能量则返回
	if get_attr_value("enegy") < amount:
		return false
	# 减少能量
	var attr_enegy = get_attr("enegy")
	attr_enegy.set_cur_value(attr_enegy.get_value() - amount)
	# 发送消息
	self.emit_signal("life_enegy_change")
	return true

# 单位死亡调用
func die():
	self.is_dead = true
	pass

# 死亡动画播放完成调用
func dead():
	self.queue_free()

	
###### 武器技能和行为操作 ######	
# 获取武器的攻击间隔
func get_attack_interval():
	return self.weapon.period

# 获取一次攻击之后等待的时间
func get_attack_time():
	return self.weapon.get_attack_time()

# 添加行为
func add_behavior(behavior):
	if behavior == null:
		return
	# 首先判断是否已经存在相同的行为
	#	如果存在则刷新该行为
	#	如果不存在则直接添加行为
	var behavior_name = Global.get_node_name(behavior)
	var has_same_behavior = false
	for b in $Behaviors.get_children():
		if Global.get_node_name(b) == behavior_name:
			has_same_behavior = true
			b.on_refresh()
	if not has_same_behavior:
		$Behaviors.add_child(behavior)
		behavior.on_add()

# 根据名称移除行为
func remove_behavior(behavior_name):
	if behavior_name.empty():
		return
	for behavior in $Behaviors.get_children():
		if Global.get_node_name(behavior) == behavior_name:
			behavior.on_remove()

# 获取单位目前携带的所有效果
func get_all_behavior():
	return $Behaviors.get_children()

# 添加技能
func add_ability(ability):
	if ability == null:
		return
	$Abilities.add_child(ability)
	# ability.on_add()

# 根据名称移除技能
func remove_ability(ability_name):
	if ability_name.empty():
		return
	for ability in $Abilities.get_children():
		if Global.get_node_name(ability) == ability_name:
			ability.on_remove()

# 获取单位目前携带的所有技能
func get_all_ability():
	return $Abilities.get_children()

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

###### 

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

###### 回调监听 ######
func _on_TimerRecover_timeout():
	recover()

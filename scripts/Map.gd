# Map.gd
extends Navigation2D

var path = []

func _ready():
	MapManager.set_map(self)
	MapManager.set_layer_unit($walls)
	MapManager.set_layer_front($FrontLayer)
	# 将地图上已经摆放的单位添加到单位管理器中
	for unit in $walls.get_children():
		UnitManager.add_unit(unit)
		if unit.is_main_character:
			UnitManager.set_main_character(unit)

func _input(event):
	if not event.is_action_pressed("click"):
		return
	_update_navigation_path(UnitManager.get_main_character().position, get_local_mouse_position())

func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class
	# it returns a PoolVector2Array of points that lead you from the
	# start_position to the end_position
	path = get_simple_path(start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove(0)
	set_process(true)

func _process(delta):
	# var walk_distance = UnitManager.get_main_character().get_attr_value("speed") * delta
	# move_along_path(walk_distance)
	unit_move_along_path(UnitManager.get_main_character())

func move_along_path(distance):
	var main_character = UnitManager.get_main_character()
	var last_point = main_character.position
	for index in range(path.size()):
		var distance_between_points = last_point.distance_to(path[0])
		# the position to move to falls between two points
		if distance <= distance_between_points:
			main_character.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			break
		# the character reached the end of the path
		elif distance < 0.0:
			main_character.position = path[0]
			set_process(false)
			break
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)

func unit_move_along_path(unit):
	var last_point = unit.position
	var direction_motion = Vector2()
	var move_rad = null
	for index in range(path.size()):
		var delta_dis = last_point.distance_to(path[index])
		# 如果到达了一个路径点，前往下一个路径点
		if delta_dis <= 10:
			path.remove(0)
			# 如果已经到达目标点，设置速度为0，返回
			if path.size() <= 0:
				break
			move_rad = path[0].angle_to_point(last_point)
			break
		else:
			# 如果没有到达当前目标路径点，向当前路径点移动
			move_rad = path[0].angle_to_point(last_point)
			break
	if move_rad != null:
		direction_motion = Vector2()
		direction_motion.x = cos(move_rad)
		direction_motion.y = sin(move_rad)
		print("direction_motion = ", move_rad, direction_motion)
	unit.motion = direction_motion.normalized()
	pass

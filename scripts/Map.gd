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
	_move_along_path()

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

func _move_along_path():
	var main_character = UnitManager.get_main_character()
	var last_point = main_character.position
	var direction_motion = null
	for index in range(path.size()):
		var delta_dis = last_point.distance_to(path[index])
		if delta_dis < 5:
			# 如果到达了一个路径点，前往下一个路径点
			path.remove(0)
			if path.size() <= 0:
				direction_motion = Vector2()
				break
			var rad = path[0].angle_to_point(last_point)
			direction_motion = Vector2()
			direction_motion.x = cos(rad)
			direction_motion.y = sin(rad)
			break
		else:
			# 如果没有到达当前目标路径点，向当前路径点移动
			var rad = path[0].angle_to_point(last_point)
			direction_motion = Vector2()
			direction_motion.x = cos(rad)
			direction_motion.y = sin(rad)
			break
	if direction_motion != null:
		print("direction_motion = ", direction_motion)
		main_character.motion = direction_motion.normalized()
	# for path_point in path:
	# 	var delta_dis = last_point.distance_to(path_point)
	# 	if delta_dis < 5:
	# 		# 如果到达了路径点，移除该路径点并向下一个路径点移动
	# 		path.remove(0)
	# 		var direction = path[0].angle_to_point(last_point)
	# 		main_character.motion = direction.normalized()
	# 		break
	pass

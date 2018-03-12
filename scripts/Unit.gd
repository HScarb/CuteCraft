extends KinematicBody2D

export(bool) var is_main_character = false

export(SpriteFrames) var sprite_frames = null
export(float) var face_angle
export(int,"north","north_east","east","south_east","south","south_west","west","north_west") var face_direction = 5

export(float) var radius		# 内部半径

const MOTION_SPEED = 260 # Pixels/second

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AnimatedSprite.frames = sprite_frames
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	if not is_main_character:
		return
	var motion = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)
	
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
	
	if motion.x == 0 and motion.y == 0:
		$AnimatedSprite.play("stand_%d" % face_direction)
	else:
		$AnimatedSprite.play("move_%d" % face_direction)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)

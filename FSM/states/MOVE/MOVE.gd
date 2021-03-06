extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################

##################################################################################
#########                       Getters and Setters                      #########
##################################################################################
#you will want to use those
func getFSM(): return fsm; #defined in parent class
func getLogicRoot(): return logicRoot; #defined in parent class 

##################################################################################
#########                 Implement those below ancestor                 #########
##################################################################################
#you can transmit parameters if fsm is initialized manually
func stateInit(inParam1=null,inParam2=null,inParam3=null,inParam4=null, inParam5=null): 
	pass

#when entering state, usually you will want to reset internal state here somehow
func enter(fromStateID=null, fromTransitionID=null, inArg0=null,inArg1=null, inArg2=null):
	print(logicRoot.name, " enter MOVE")
	logicRoot.is_moving = true
	pass

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	# 建立motion
	# if logicRoot.is_main_character:
	# 	logicRoot.motion = Vector2()
	# 	# 设置motion
	# 	if Input.is_action_pressed("ui_up"):
	# 		logicRoot.motion += Vector2(0, -Global.Y_ZOOM)
	# 	if Input.is_action_pressed("ui_down"):
	# 		logicRoot.motion += Vector2(0, Global.Y_ZOOM)
	# 	if Input.is_action_pressed("ui_left"):
	# 		logicRoot.motion += Vector2(-Global.X_ZOOM, 0)
	# 	if Input.is_action_pressed("ui_right"):
	# 		logicRoot.motion += Vector2(Global.X_ZOOM, 0)
	logicRoot.refresh_face_angel_by_motion()

	# 移动
	# logicRoot.motion = logicRoot.motion.normalized() * logicRoot.get_attr_value("speed")
	logicRoot.move()

#when exiting state
func exit(toState=null):
	logicRoot.is_moving = false
	pass

##################################################################################
#########                       Connected Signals                        #########
##################################################################################

##################################################################################
#########     Methods fired because of events (usually via Groups interface)  ####
##################################################################################

##################################################################################
#########                         Public Methods                         #########
##################################################################################

##################################################################################
#########                         Inner Methods                          #########
##################################################################################

##################################################################################
#########                         Inner Classes                          #########
##################################################################################

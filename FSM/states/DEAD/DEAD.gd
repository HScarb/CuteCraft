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
	print("enter DEAD")
	# 播放死亡动画
	# 死亡动画规则:
	# - 如果有4方向的死亡动画，根据单位的当前朝向播放
	# - 否则随机播放一个死亡动画
	var dir = logicRoot.face_direction
	var frames = logicRoot.get_node("AnimatedSprite").frames
	if frames.has_animation("death_0"):
		# 如果有4方向死亡动画
		match dir:
			0, 1, 7:
				logicRoot.emit_signal("play_animation", "death_0")
			2:
				logicRoot.emit_signal("play_animation", "death_1")
			3, 4, 5:
				logicRoot.emit_signal("play_animation", "death_2")
			6:
				logicRoot.emit_signal("play_animation", "death_3")
	else:
		# 如果没有，随机一个死亡动画
		randomize()
		logicRoot.is_dead = true
		# 	统计死亡动画个数
		var death_anim_num = 0
		while frames.has_animation("death%d" % death_anim_num):
			death_anim_num += 1
		var i = randi() % death_anim_num
		# 	随机播放死亡动画
		logicRoot.emit_signal("play_animation", "death%d" % i)
	pass

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	pass

#when exiting state
func exit(toState=null):
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

extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var attack_time = 0

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
	print("enter ATTACK")
	logicRoot.is_attacking = true
	# 开始时播放一次攻击动画
	attack_time = 0
	logicRoot.get_node("AnimatedSprite").play("attack_%d" % logicRoot.face_direction)
	# logicRoot.get_node("AnimatedSprite").frames.set_animation_loop("attack_%d" % logicRoot.face_direction, true)
	pass

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	# 播放动画
	attack_time += deltaTime
	if attack_time >= logicRoot.get_attack_interval():
		attack_time = 0
		logicRoot.get_node("AnimatedSprite").play("attack_%d" % logicRoot.face_direction)
	# logicRoot.get_node("AnimatedSprite").play("attack_%d" % logicRoot.face_direction)
	pass

#when exiting state
func exit(toState=null):
	print("exit ATTACK")
	logicRoot.is_attacking = false
	pass

##################################################################################
#########                       Connected Signals                        #########
##################################################################################
func _on_AnimatedSprite_animation_finished():
	print("Animate finished")
	logicRoot.get_node("AnimatedSprite").stop()
	pass # replace with function body

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
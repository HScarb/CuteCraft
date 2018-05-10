extends "res://scripts/Effect/EffectTreeNode.gd"

# virtual
# 发送全局消息
func run():
	print("run effect ", self.get_name())
	# 发送全局消息
	SignalManager.emit_signal("effect_start", self)
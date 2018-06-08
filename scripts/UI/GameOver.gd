# GameOver.gd
extends ColorRect

func init():
    SignalManager.connect("game_over", self, "set_visible", [true])
    set_visible(false)

func _on_ButtonRestart_pressed():
	SignalManager.emit_signal("game_restart")

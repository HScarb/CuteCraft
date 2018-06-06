# ModelSprite.gd
extends Sprite

export(bool)var free_after_finished = false					# 是否在动画结束之后销毁

var sprite = null setget , get_sprite

func _init():
	sprite = $Sprite

func init():
	self.connect("tree_entered", self, "play_animation")

func play_animation():
	$Sprite/AnimationPlayer.play("default")

func _on_AnimationPlayer_animation_finished(anim_name):
	if free_after_finished:
		queue_free()

func get_sprite():
	return $Sprite

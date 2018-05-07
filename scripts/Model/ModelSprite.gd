# ModelSprite.gd
extends Sprite

export(bool)var free_after_finished = false					# 是否在动画结束之后销毁

func _on_AnimationPlayer_animation_finished(anim_name):
	if free_after_finished:
		queue_free()


extends Node

func _on_cut_scene_state_entered():
	get_parent().anim.play("Idle")

func _on_cut_scene_state_physics_processing(delta):
	get_parent().player.velocity = Vector2.ZERO

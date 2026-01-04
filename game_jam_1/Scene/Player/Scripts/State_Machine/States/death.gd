extends Node

func _on_hurt_box_health_depleated():
	get_parent().player.is_dead = true

func _on_dead_state_entered():
	Global.need_to_reload = true
	get_parent().anim.play("Death")
	await get_parent().anim.animation_finished
	get_tree().reload_current_scene()

func _on_dead_state_physics_processing(delta):
	get_parent().player.velocity = Vector2.ZERO

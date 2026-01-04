extends Node

func _on_idle_state_entered():
	get_parent().anim.play("Idle_With_Sword")

func _on_idle_state_physics_processing(delta):
	var player = get_parent().player
	player.velocity.x = move_toward(player.velocity.x, 0, player.deaccel * delta)

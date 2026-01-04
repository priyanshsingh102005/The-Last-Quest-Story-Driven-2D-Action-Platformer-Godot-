extends Node

func _on_run_state_entered():
	get_parent().anim.play("Run_With_Sword")

func _on_run_state_physics_processing(delta):
	var player = get_parent().player
	player.velocity.x = lerp(player.velocity.x, player._dir().x * player.speed, player.accel * delta)

extends Node

@export var attack_cool_down:Timer

var next_attack:bool = false

func combo_window():
	next_attack = true

func _on_combo_1_state_entered():
	_attack("Attack_1")

func _on_combo_2_state_entered():
	_attack("Attack_2")

func _on_combo_state_physics_processing(delta):
	_next_attack()

func _on_combo_state_exited():
	_end_of_attack()

func _on_attack_cool_down_timeout():
	get_parent().player.can_attack = true

func _attack(name:String):
	var time = 0.5 if name == "Attack_1" else 0.3
	if attack_cool_down.is_stopped():
		get_parent().anim.play(name)
		attack_cool_down.start(time)

func _next_attack():
	if Input.is_action_pressed("Attack") and next_attack == true:
		get_parent().state_chart.send_event("next")

func _end_of_attack():
	next_attack = false
	attack_cool_down.stop()

func _on_attacks_state_physics_processing(delta):
	get_parent().player.velocity = Vector2.ZERO

extends Node

@export var anim: AnimationPlayer
@export var state_chart:StateChart
@export var hurt_box:Area2D
@export var hit_box:Area2D
@export var health_bar:ProgressBar
@onready var player = get_parent()

func _ready():
	health_bar._init_health(hurt_box.max_health)

func _transition():
	if player.is_dead == false:
		if player.is_hurt == false:
			if Global.cut_scene_triggered == false and player.can_move:
				if player.is_on_floor():
					state_chart.send_event("ground")
				else:
					state_chart.send_event("air")
		
				if player.can_attack:
					player.flip()
			else:
				state_chart.send_event("cut_scene")
		else:
			state_chart.send_event("hurt")
	else:
		state_chart.send_event("dead")

func _on_ground_state_physics_processing(_delta):
	if player.can_attack:
		if player._dir().x != 0:
			state_chart.send_event("run")
		else:
			state_chart.send_event("idle")
		
		hit_box._disabling_child_hitboxes(true)
		
		if Input.is_action_just_pressed("Attack"):
			player.can_attack = false
	else:
		state_chart.send_event("attack")

func _on_air_state_physics_processing(_delta):
	
	if player.velocity.y >= 0:
		state_chart.send_event("fall")

func _on_hurt_box_health_updated(health):
	health_bar._set_health(health)

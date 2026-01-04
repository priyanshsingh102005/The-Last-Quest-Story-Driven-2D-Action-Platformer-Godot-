extends Node2D

@export var accel_x:float = 2.0
@export var accel_y:float = 1.0

@export var dead_zone:Area2D

var need_to_follow:bool = false

func _physics_process(delta):
	if Global.player:
		if need_to_follow == true:
			global_position.x = lerp(global_position.x,Global.player.global_position.x, accel_x * delta)
			global_position.y = lerp(global_position.y,Global.player.global_position.y, accel_y * delta)


func _on_stable_zone_body_entered(body):
	if body is CharacterBody2D:
		need_to_follow = false
		dead_zone.set_deferred("monitorable", false)
		dead_zone.set_deferred("monitoring", false)
		

func _on_stable_zone_body_exited(body):
	if body is CharacterBody2D:
		dead_zone.set_deferred("monitorable", true)
		dead_zone.set_deferred("monitoring", true)
		need_to_follow = true

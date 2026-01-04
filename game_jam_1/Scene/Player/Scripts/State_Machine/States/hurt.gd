extends Node

@export var invinsibility_timer:Timer
@export var invinsibility_anim:AnimationPlayer
@export var right:ShapeCast2D
@export var left:ShapeCast2D

var invinsibility:bool = false

var knock: bool = false
var knock_force:float = 200
var knock_velocity: Vector2 = Vector2.ZERO
var knock_duration: float = 0.2  # seconds of knockback
var knock_timer: float = 0.0

func _on_hurt_box_area_entered(area):
	Global.cam.screen_shake(7,0.2)
	Global._freeze(0.4, 0.2)
	get_parent().player.is_hurt = true
	get_parent().hurt_box._take_damage(area.damage)
	
	# Trigger knockback
	knock = true
	
	var dir = 0

	if right.is_colliding():
		dir = -1
	elif left.is_colliding():
		dir = 1

	knock_velocity.x = dir * knock_force
	knock_timer = knock_duration

func _on_hurt_state_entered():
	invinsibility_timer.start()
	invinsibility_anim.play("anim")
	invinsibility = true
	get_parent().anim.play("Hurt")

func _on_hurt_state_physics_processing(delta):
	if knock:
		get_parent().player.velocity.x = knock_velocity.x
		knock_timer -= delta
		if knock_timer <= 0:
			knock = false
			get_parent().player.velocity = Vector2.ZERO

func _on_invinsibility_timer_timeout():
	invinsibility_anim.stop()
	invinsibility_anim.play("RESET")

extends CharacterBody2D

enum states{
	IDLE,
	ATTACK,
	HURT,
	DEAD
}

@export var speed:float = 60.0
@export var accel:float = 30.0
@export var gravity:float = 150.0
@export_range(-1,1) var dir:int = -1

@export var left_dir:RayCast2D
@export var right_dir:RayCast2D
@export var body:Node2D
@export var hurt_box:Area2D

@export var state:states = states.IDLE

@export var anim:AnimationPlayer
@export var can_attack:bool = false
@export var is_hurt:bool = false
@export var can_move:bool = true

var is_dead:bool = false

func _physics_process(delta):
	_state_transition(delta)
	_state_transition_condition()
	move_and_slide()
	_gravity(delta)

func _gravity(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func _state_transition(delta):
	body.scale.x = _set_dir() * -1
	match state:
		states.IDLE:
			anim.play("Idle")
			velocity.x = 0
		states.ATTACK:
			anim.play("Attack")
			velocity.x = lerp(velocity.x, speed * _set_dir(), accel * delta)
			await anim.animation_finished
			velocity.x = 0
		states.HURT:
			anim.play("Hurt")
			velocity = Vector2.ZERO
		states.DEAD:
			velocity = Vector2.ZERO
			anim.play("Dead")
			await anim.animation_finished
			queue_free()

func _state_transition_condition():
	if can_move:
		if is_dead:
			state = states.DEAD
			return
		
		if is_hurt:
			state = states.HURT
		else:
			if can_attack:
				state = states.ATTACK
			else:
				state = states.IDLE
	else:
		state = states.IDLE

func _set_dir():
	if right_dir.is_colliding():
		dir =  1
	elif left_dir.is_colliding():
		dir = -1
	return dir

func _on_player_detector_body_entered(body):
	can_attack = true

func _on_player_detector_body_exited(body):
	if anim.current_animation == "Attack":
		anim.animation_finished
		can_attack = false

func _on_hurt_box_area_entered(area):
	is_hurt = true
	state = states.HURT
	hurt_box._take_damage(area.damage)

func _on_hurt_box_health_depleated():
	is_dead = true

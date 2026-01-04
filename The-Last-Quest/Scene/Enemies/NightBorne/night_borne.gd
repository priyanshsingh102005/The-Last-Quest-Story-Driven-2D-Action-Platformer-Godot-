extends CharacterBody2D

@export var gravity:float=  150
@export var speed: float = 70.0
@export var pause_time: float = 0.5
@export var can_move: bool = false  # Boss starts inactive

@onready var hurt_box = $Body/Hurt_Box
@onready var animation_player = $Body/AnimationPlayer
@onready var body = $Body

enum { IDLE, CHASE, ATTACK, PAUSE , HURT,DEATH}
var state = IDLE

var is_in_attack_range:bool = false
var is_hurt:bool = false
var is_dead:bool = false

var count = 0

func _physics_process(delta):
	_state_match(delta)
	_state_transition()
	_gravity(delta)
	move_and_slide()

func _state_match(delta):
	match state:
		IDLE:
			velocity.x = 0
			animation_player.play("Idle")
		CHASE:
			animation_player.play("Walk")
			var direction = (Global.player.global_position - global_position).normalized()
			body.scale.x = sign(direction.x)
			velocity.x = direction.x * speed
		ATTACK:
			velocity.x = 0
			animation_player.play("Attack")
		HURT:
			velocity.x = 0
			animation_player.play("Hurt")
			await animation_player.animation_finished
			is_hurt = false
		DEATH:
			velocity.x = 0
			if count == 0:
				$"../Walls/AnimationPlayer".play("RESET")
				animation_player.play("Death")
				count = 1
	
	_state_transition()
	
func _state_transition():
	if Global.cut_scene_triggered:
		state = IDLE
		return
	
	if is_dead:
		state = DEATH
		return
	
	if is_hurt:
		state = HURT
		return
	
	if is_in_attack_range:
		state = ATTACK
		return
	else:
		if can_move:
			state = CHASE
		else:
			state = IDLE

func _gravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta


func _on_hurt_box_health_depleated():
	is_dead = true

func _on_hurt_box_area_entered(area):
	hurt_box._take_damage(area.damage)
	is_hurt = true

func _on_attack_zone_body_entered(body):
	is_in_attack_range = true

func _on_attack_zone_body_exited(body):
	if animation_player.current_animation == "Attack":
		await animation_player.animation_finished
		is_in_attack_range = false

func _on_dialoges_cutscene_ended():
	can_move = true
	$"../Walls/AnimationPlayer".play("anim")

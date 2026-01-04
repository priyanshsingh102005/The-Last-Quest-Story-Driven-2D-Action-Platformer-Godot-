extends CharacterBody2D

enum{
	WALK,
	CHASE,
	ATTACK,
	HURT,
	DEAD
}

var state = WALK

@onready var timer = $Timer
@onready var animation_player = $Body/AnimationPlayer
@onready var hurt_box = $Body/Hurt_Box
@onready var body = $Body

@export var gravity:float = 150
@export var speed:float = 20
@export var accel:float= 5
@export var chase_speed:float = 23

var direction:int = 1
var player_in_range:bool = false
var player_in_attack_range:bool = false

var is_hurt = false
var is_dead = false

var count = 0

func _physics_process(delta):
	_state_match(delta)
	move_and_slide()
	_gravity(delta)

func _gravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta

func _state_match(delta):
	match state:
		WALK:
			if timer.is_stopped():
				timer.start(randf_range(1.8,3.2))
			body.scale.x = direction
			animation_player.play("Walk")
			velocity.x = lerp(velocity.x, speed * direction , accel * delta)
		CHASE:
			animation_player.play("Walk")
			var dir = (Global.player.global_position - global_position).normalized()
			body.scale.x = sign(dir.x)
			velocity.x = dir.x * chase_speed
		ATTACK:
			velocity = Vector2.ZERO
			animation_player.play("Attack")
		HURT:
			animation_player.play("Hurt")
			await animation_player.animation_finished
			is_hurt = false
			velocity = Vector2.ZERO
		DEAD:
			velocity = Vector2.ZERO
			if count == 0:
				count = 1
				animation_player.play("Dead")
	
	_state_transition()

func _state_transition():
	
	if Global.cut_scene_triggered:
		animation_player.play("Idle")
		velocity.x = 0
		return
	
	if is_dead:
		state = DEAD
		return
	
	if is_hurt:
		state = HURT
		return
	
	if player_in_attack_range:
		state = ATTACK
		return
	else:
		if player_in_range:
			state = CHASE
		else:
			state = WALK


func _on_player_detector_body_entered(body):
	player_in_range = true

func _on_player_detector_body_exited(body):
	player_in_range = false

func _on_attack_zone_body_entered(body):
	player_in_attack_range = true

func _on_attack_zone_body_exited(body):
	if animation_player.current_animation == "Attack":
		await animation_player.animation_finished
		player_in_attack_range = false

func _on_hurt_box_area_entered(area):
	hurt_box._take_damage(area.damage)
	is_hurt = true

func _on_hurt_box_health_depleated():
	is_dead = true


func _on_timer_timeout():
	direction *= -1

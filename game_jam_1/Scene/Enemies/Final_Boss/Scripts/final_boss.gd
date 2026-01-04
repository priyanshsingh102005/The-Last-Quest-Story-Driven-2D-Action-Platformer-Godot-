extends CharacterBody2D

signal dead

enum {
	IDLE,
	RUN,
	ATTACKS,
	ABILITY_1,
	ABILITY_2,
	HURT,
	DEAD
}

var current_state = IDLE
var prev_state = null

@export var anim:AnimationPlayer
@export var water_effect:Node2D
@export var lightning_effect:Node2D
@export var body:Node2D
@export var hit_box:Area2D
@export var hurt_box = Area2D
@export var health_bar:ProgressBar

@export var timer:Timer
@export var move_speed: float = 100.0
@export var chase_distance: float = 25.0
@export var wait_time_before_chase: float = 0.9
@export var gravity:float = 150.0
@export var hits_for_special: int = 4
@export var count:int = 0

var can_move:bool = false
var current_hits: int = 0
var can_attack :bool = true
var waiting_to_chase :bool = false
var is_hurt = false
var is_dead = false
var played_dead = false  # NEW: tracks if dead animation already played

func _ready():
	health_bar._init_health(hurt_box.max_health)
	health_bar.visible = false

func _physics_process(delta):
	if is_dead:
		# Block everything if dead
		velocity = Vector2.ZERO
		if not played_dead:
			played_dead = true
			anim.play("Dead")
			await anim.animation_finished
			anim.play("Dead_end")
			emit_signal("dead")
		return  # Skip everything else

	if Global.player == null:
		anim.play("Idle")
		return
	
	if Global.player.is_dead == false:
		if can_move:
			_state_transition(delta)
			_state_transition_condition(_check_distance(), delta)
		else:
			velocity = Vector2.ZERO
			anim.play("Idle")
	else:
		velocity.x = 0
		anim.play("Idle")
	
	_gravity(delta)
	move_and_slide()


func _state_transition(delta):
	if anim.current_animation == "Idle":
		hit_box._disabling_child_hitboxes(true)
	
	match current_state:
		IDLE:
			anim.play("Idle")
			velocity.x = 0
		RUN:
			if timer.is_stopped():
				timer.start(randi_range(1,3))
			# Move toward player
			anim.play("Run")
			var dir = (Global.player.global_position - global_position).normalized()
			body.scale.x = -sign(dir.x)
			velocity.x = dir.x * move_speed
		ATTACKS:
			velocity = Vector2.ZERO
			var attacks = ["Attack_1", "Attack_2", "Attack_3"]
			anim.play(attacks[count])
		ABILITY_1:
			water_effect.activated = true
			velocity.x = 0
			current_hits = 0
			is_hurt = false
		ABILITY_2:
			anim.play("Idle")
			lightning_effect.activated = true
			velocity.x = 0
			is_hurt = false
			await get_tree().create_timer(0.5).timeout
			_set_state(current_state,RUN)
		HURT:
			velocity = Vector2.ZERO
			anim.play("Hurt")
		DEAD:
			velocity = Vector2.ZERO
			if not played_dead:
				anim.play("Dead")
				played_dead = true
				# Wait for Dead to finish
				await anim.animation_finished
				anim.play("Dead_end")  # Ensure Dead_end is non-looping

func _state_transition_condition(distance, delta):
	if is_dead:
		# Prevent any further state changes after death
		return
	
	if is_hurt == false:
		if current_hits > hits_for_special:
			_set_state(current_hits, ABILITY_1)
		else:
			if can_attack:
				count = 0
				# If player too far, wait before chasing
				if distance > chase_distance and not waiting_to_chase:
					waiting_to_chase = true
					await get_tree().create_timer(wait_time_before_chase).timeout
					if Global.player and global_position.distance_to(Global.player.global_position) > chase_distance:
						_set_state(current_state, RUN)
					waiting_to_chase = false
				# Switch to idle if player is closer
				elif distance <= chase_distance:
					_set_state(current_state,IDLE)
			else:
				_set_state(current_state,ATTACKS)
	else:
		if is_hurt:
			_set_state(current_state, HURT)

func _check_distance():
	var distance = global_position.distance_to(Global.player.global_position) if Global.player != null else 1
	return distance

func _set_state(prev, next):
	if next != prev:
		prev_state = prev
		current_state = next

func _gravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta

func _on_attack_zone_body_entered(_body):
	can_attack = false

func _on_attack_zone_body_exited(_body):
	can_attack = true 
	_set_state(current_state,IDLE)

func _on_hurt_box_area_entered(area):
	if water_effect.activated == false:
		is_hurt = true
		current_hits += 1
		hurt_box._take_damage(area.damage)

func _on_hurt_box_health_depleated():
	is_dead = true

func _on_water_effect_finished():
	_set_state(current_state,IDLE)

func _on_dialoges_cutscene_ended():
	can_move = true
	health_bar.visible = true

func _on_timer_timeout():
	if is_dead == false:
		_set_state(current_state, ABILITY_2)
	else:
		return

func _on_hurt_box_health_updated(health):
	health_bar._set_health(health)

func _reset_hurt():
	is_hurt = false

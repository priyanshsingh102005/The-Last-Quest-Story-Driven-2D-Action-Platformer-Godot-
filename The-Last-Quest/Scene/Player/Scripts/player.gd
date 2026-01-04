extends CharacterBody2D

@export var speed: float = 90.0
@export var fall_gravity: float = 350.0
@export var gravity: float = 290.0
@export var jump_velocity: float = -170.0
@export var accel: float = 10
@export var deaccel: float = 450
@export var coyote_time :float = 0.2
@export var var_jump_multiplier:float = 0.5

@export var body:Node2D
@export var state_manager:Node

@export var can_move:bool = true

var coyote_timer :float = 0.0
var can_attack:bool = true
var is_hurt: bool = false
var is_dead: bool = false
var input_dir: Vector2

func _ready():
	Global.player = self

func _physics_process(delta):
	state_manager._transition()
	
	if Global.cut_scene_triggered == false and can_move:
		_gravity_and_jump_mechanic(delta)
	else:
		velocity.y += gravity * delta
		if is_on_floor():
			$body/AnimationPlayer.play("Idle")
			velocity.x = 0
	
	move_and_slide()

func flip():
	if _dir().x != 0:
		body.scale.x = _dir().x
	_dir()

func _gravity_and_jump_mechanic(delta):
	coyote_timer = clamp(coyote_timer, 0,coyote_time)
	var GRAVITY = gravity if velocity.y < 0.0 else fall_gravity
	
	if !is_on_floor():
		coyote_timer -= delta
		
		velocity.y += GRAVITY * delta
		
		if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
			velocity.y = jump_velocity
			coyote_timer = 0.0

		
		if Input.is_action_just_released("jump") and velocity.y < 0.0:
			velocity.y *= var_jump_multiplier
			
	else:
		coyote_timer = coyote_time
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity

func _dir():
	# checking input of player
	input_dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0).normalized()
	return input_dir

func _not_hurt():
	is_hurt = false

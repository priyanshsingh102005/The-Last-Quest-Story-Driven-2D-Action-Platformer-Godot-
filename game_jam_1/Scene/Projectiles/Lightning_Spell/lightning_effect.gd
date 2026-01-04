extends CharacterBody2D

@export var parent:CharacterBody2D

@export var start_moving:bool = false
@export var speed : float = 170.0
@export var accel : float = 80.0
@export var cool_down:float = 8.0

@export var remote:RemoteTransform2D
@export var anim:AnimationPlayer
@export var body:Node2D
@export var activated:bool = false

@export var hit_box:Area2D

var timer:float = 0.0
var intial_point:Vector2
var is_hit = false
var initiated = false

func _ready():
	remote.update_position = true
	timer = cool_down

func _physics_process(delta):
	if activated:
		activate(delta)

func activate(delta):
	if Global.cut_scene_triggered == false and initiated == false and is_hit == false:
		initiated = true
		_start()

	_cool_down_timer(delta)
	
	if start_moving:
		move_and_slide()
	
	_move(delta)
	
	if initiated == false:
		body.scale.x = parent.body.scale.x
	

func _start():
	intial_point = global_position
	visible = true
	
	if is_hit == false:
		remote.update_position = false
		anim.play("start")
		await anim.animation_finished
		anim.play("mid")

func _move(delta):
	velocity.x = lerp(velocity.x, speed * body.scale.x * -1, accel * delta)

func _on_wall_detector_body_entered(body):
	is_hit = true
	activated = false
	velocity = Vector2.ZERO
	anim.play("hit")

func _cool_down_timer(delta):
	if initiated == true:
		timer -= delta
		timer = clamp(timer, 0, cool_down)
		
		
		if timer == 0.0:
			is_hit = false
			timer = cool_down
			initiated = false

func _end():
	_return()

func _return():
	anim.stop()
	anim.play("RESET")
	remote.update_position = true
	visible = false
	global_position = intial_point

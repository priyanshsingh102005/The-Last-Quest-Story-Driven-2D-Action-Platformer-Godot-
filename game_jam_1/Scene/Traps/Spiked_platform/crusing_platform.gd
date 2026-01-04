extends CharacterBody2D

@export var gravity: float = 3000.0
@export var rise_speed: float = 100.0
@export var wait_time: float = 1.2
@export var top_position_y: float = 0.0  # set automatically

var falling: bool = true
var grounded: bool = false

@onready var wait_timer: Timer = $wait_timer
var paused: bool = false  # Add this at the top

func _ready():
	top_position_y = global_position.y  # Remember initial position
	wait_timer.one_shot = true
	wait_timer.connect("timeout", Callable(self, "_on_wait_timer_timeout"))

func _physics_process(delta):
	if paused:
		return  # Stop moving while waiting

	if falling:
		velocity.y += gravity * delta
	else:
		velocity.y = -rise_speed

	var collision = move_and_collide(velocity * delta)

	if collision and falling:
		# Slammed ground
		falling = false
		velocity = Vector2.ZERO
		paused = true  # <--- pause here
		wait_timer.start(wait_time)

	elif not falling and global_position.y <= top_position_y:
		global_position.y = top_position_y
		velocity = Vector2.ZERO
		falling = true
		paused = true
		wait_timer.start(wait_time)

func _on_wait_timer_timeout():
	paused = false  # resume movement after timer

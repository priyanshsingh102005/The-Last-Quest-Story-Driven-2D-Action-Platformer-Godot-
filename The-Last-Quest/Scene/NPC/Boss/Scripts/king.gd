extends CharacterBody2D

enum states{
	IDLE,
	RUN
}

@export var anim:AnimationPlayer
@export var state:states

func _physics_process(delta):
	state_assign()

func state_assign():
	match state:
		states.IDLE:
			anim.play("Idle")
		states.RUN:
			anim.play("Run")

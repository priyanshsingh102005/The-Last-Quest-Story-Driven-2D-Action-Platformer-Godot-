extends Node2D

signal finished

@export var duration:float = 3.0
@export var anim:AnimationPlayer
@export var activated:bool = false

var timer:float = 0.0
var initiated = false

func _ready():
	visible = false
	timer = duration

func _physics_process(_delta):
	if activated:
		activate()

func activate():
	if Global.cut_scene_triggered == false and initiated == false:
		initiated = true
		visible = true
		anim.play("start")
		await anim.animation_finished
		anim.play("mid")
	
	
	if initiated == true:
		_cool_down_timer(get_physics_process_delta_time())
		if timer <= 0.0:
			anim.play("hit")
			await anim.animation_finished
			emit_signal("finished")
			visible = false
			initiated = false
			timer = duration
			activated = false

func _cool_down_timer(delta):
	timer -= delta
	timer = clamp(timer, 0 ,duration)

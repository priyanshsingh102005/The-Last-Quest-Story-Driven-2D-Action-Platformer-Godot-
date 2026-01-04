extends Node

var player:CharacterBody2D
var cam:Camera2D
var need_to_reload:bool = false
var cut_scene_triggered :bool = false

func _ready():
	need_to_reload = false

func _freeze(timeScale,duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0

func _reload(check_point,health):
	player.global_position = check_point.global_position
	player.state_manager.hurt_box.health = health

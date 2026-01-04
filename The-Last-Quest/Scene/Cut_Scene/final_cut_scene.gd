extends Node2D

@export var bgm_2:AudioStreamPlayer
@onready var collision_shape_2d = $Dialogesend/Trigger_Area/CollisionShape2D
@onready var player_return = $return_points/Player_return
@onready var final_boss_return = $return_points/Final_boss_return
@onready var animation_player = $CanvasLayer/AnimationPlayer
@onready var player = $Player
@onready var final_boss = $Final_Boss
@onready var ignite = $ignite/CollisionShape2D
@onready var ignition = $ignite/Ignition

var ignition_area_entered = false
var ignition_active = false

func _ready():
	ignition.visible = false
	collision_shape_2d.set_deferred("disabled",true)
	ignite.set_deferred("disabled",true)

func _on_dialoges_cutscene_ended():
	bgm_2.play()

func _on_final_boss_dead():
	await get_tree().create_timer(0.5).timeout
	animation_player.play("anim")
	await animation_player.animation_finished
	player.global_position = player_return.global_position
	final_boss.global_position = final_boss_return.global_position
	
	await get_tree().create_timer(1).timeout
	animation_player.play("anim",-1,-1,true)
	await  animation_player.animation_finished
	collision_shape_2d.set_deferred("disabled",false)
	ignite.set_deferred("disabled",false)

func _physics_process(delta):
	_ignite()

func _ignite():
	if ignition_area_entered and Global.cut_scene_triggered == false:
		if Input.is_action_just_pressed("interact") and ignition_active == false:
			ignition_active = true
			ignition.visible = true
			ignition._active()
			await get_tree().create_timer(0.6).timeout
			final_boss.visible = false
	else:
		pass

func _on_ignite_body_entered(body):
	ignition_area_entered = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "anim":
		ignite.set_deferred("disabled",true)
		ignition.visible = false
	
	
	Global.cut_scene_triggered = true
	bgm_2.fade_out()
	animation_player.play("anim")
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://Scene/Credits/Credits.tscn")

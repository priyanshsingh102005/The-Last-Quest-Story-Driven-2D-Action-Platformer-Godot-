extends Node2D

@export var bgm:AudioStreamPlayer
@export var check_point:Node2D
@export var next_scene:String
@export var anim:AnimationPlayer

func _change_scene(scene):
	bgm.fade_out(2)
	anim.play("anim")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene)

func _on_next_scene_body_entered(body):
	_change_scene(next_scene)

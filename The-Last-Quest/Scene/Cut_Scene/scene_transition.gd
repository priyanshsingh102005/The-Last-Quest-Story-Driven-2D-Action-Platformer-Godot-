extends Node2D

@export var bgm:AudioStreamPlayer
@export var next_scene:String
@export var anim:AnimationPlayer

func _change_scene(scene):
	anim.play("next_scene")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene)

func _on_dialoges_cutscene_ended():
	bgm.fade_out(2)
	_change_scene(next_scene)

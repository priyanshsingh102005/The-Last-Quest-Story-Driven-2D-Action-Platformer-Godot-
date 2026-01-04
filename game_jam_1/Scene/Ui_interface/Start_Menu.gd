extends Control

@export var sound:AudioStreamPlayer
@export var anim:AnimationPlayer

func _on_start_pressed():
	sound.fade_out()
	anim.play("anim")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Scene/Cut_Scene/scene_1.tscn") # Replace with your game scene path
	

func _on_quit_pressed():
	sound.fade_out()
	anim.play("anim")
	await anim.animation_finished
	get_tree().quit()

func _on_credit_pressed():
	sound.fade_out()
	anim.play("anim")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Scene/Credits/Credits.tscn") # Replace with your game scene path

extends Node2D


func _active():
	$body/AnimationPlayer.play("anim")

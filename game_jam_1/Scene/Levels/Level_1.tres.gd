extends Node2D

@export var bgm:AudioStreamPlayer
@export var check_point:Node2D
@export var next_scene:String
@export var anim:AnimationPlayer

var count = 0

func _change_scene(scene):
	anim.play("next_scene")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene)

func _physics_process(delta):
	if Global.need_to_reload == true:
		Global.need_to_reload = false
		if Global.player.is_dead == false:
			Global._reload(check_point,Global.player.state_manager.hurt_box.health - 30)

func _on_next_scene_body_entered(_body):
	bgm.fade_out(2)
	_change_scene(next_scene)

func _on_playable_area_body_exited(body):
	Global.need_to_reload = true

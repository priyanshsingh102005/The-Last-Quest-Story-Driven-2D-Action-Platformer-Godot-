extends Node2D
class_name Cut_Scene

signal cutscene_started
signal cutscene_ended

enum cut_scene{
	External_trigger,
	Self_Trigger
}

@export var trigger_type:cut_scene

@export var anim:AnimationPlayer
@export var text_anim:AnimationPlayer
@export var dialogues: Array[DialogueData]
@export var dialogue_manager: NodePath
@export var text_anim_finished:bool = true
@export var convo:RichTextLabel

var cut_scene_triggered: bool = false
var player_entered:bool = false
var cut_scene_finished:bool = false

var manager: Node
var current_index :int = 0

func _physics_process(delta):
	match trigger_type:
		cut_scene.External_trigger:
			if Input.is_action_just_pressed("interact") and player_entered and cut_scene_triggered == false:
				if cut_scene_finished == false:
						cut_scene_triggered = true
						anim.play("start")
						text_anim_finished = false
						text_anim.play("anim")
						start_cutscene()
			else:
				pass
		
		cut_scene.Self_Trigger:
			if cut_scene_triggered == false and player_entered:
				if cut_scene_finished == false:
					cut_scene_triggered = true
					anim.play("start")
					text_anim_finished = false
					text_anim.play("anim")
					start_cutscene()
	

func start_cutscene():
	manager = get_node(dialogue_manager)
	Global.cut_scene_triggered = true
	_show_dialogue()

func _input(event):
	if cut_scene_triggered and event.is_action_pressed("interact") and text_anim_finished == true:
		current_index += 1
		text_anim.play("anim")
		_show_dialogue()

func _show_dialogue():
	if current_index < dialogues.size():
		manager.show_dialogue(dialogues[current_index])
	else:
		text_anim.stop()
		text_anim.play("RESET")
		end_cutscene()

func end_cutscene():
	cut_scene_triggered = false
	anim.play("end")
	emit_signal("cutscene_ended")
	cut_scene_finished = true
	Global.cut_scene_triggered = false


func _on_trigger_area_body_entered(body):
	if body is CharacterBody2D:
		player_entered = true

func _on_trigger_area_body_exited(body):
	if body is CharacterBody2D:
		player_entered = false

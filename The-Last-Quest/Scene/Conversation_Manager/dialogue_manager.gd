extends Node2D

@export var portrates: Array[TextureRect]
@export var labels:Array[Label]
@export var texts:RichTextLabel

func show_dialogue(dialogue: DialogueData):
	var side_index = 0 if dialogue.side == "left" else 1
	var other_index = 1 - side_index
	
	portrates[side_index].texture = dialogue.portrait
	portrates[side_index].modulate = Color(1,1,1,1)        # highlight
	labels[side_index].text = dialogue.speaker_name
	
	labels[side_index].visible = true
	
	portrates[other_index].modulate = Color(1,1,1,0.5)
	labels[other_index].visible = false
	texts.text =  dialogue.text

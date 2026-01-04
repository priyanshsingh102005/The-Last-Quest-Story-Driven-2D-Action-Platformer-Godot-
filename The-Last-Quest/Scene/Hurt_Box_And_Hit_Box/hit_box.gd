extends Area2D

@export var damage:float = 10.0

func _disabling_child_hitboxes(do):
	if do:
		do = false
		for i in get_children():
			i.set_deferred("disabled", true)

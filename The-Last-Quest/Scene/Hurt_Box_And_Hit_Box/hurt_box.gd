extends Area2D

signal health_updated(health)
signal health_depleated()

@export var max_health:float = 100.0

var health

func _ready():
	health = max_health

func _physics_process(_delta):
	update_health()

func _take_damage(damage):
	health -= damage

func update_health():
	health = clamp(health, 0, max_health)
	if health != max_health:
		emit_signal("health_updated", health)
		if health == 0:
			emit_signal("health_depleated")

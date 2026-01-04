extends CanvasLayer

@onready var grid = $Control/VBoxContainer/GridContainer
@onready var prev_button = $Control/VBoxContainer/HBoxContainer/prev
@onready var next_button = $Control/VBoxContainer/HBoxContainer/next

@export var credits_data: Array[CreditEntry]
var current_index: int = 0

func _ready():
	_update_display()

func _physics_process(delta):
	current_index = clamp(current_index,0,credits_data.size())

func _update_display():
	# Clear old elements
	for child in grid.get_children():
		child.queue_free()

	# Header row
	var headers = ["Asset", "License", "Creator / Website"]
	for h in headers:
		var label = Label.new()
		label.text = h
		label.add_theme_color_override("font_color", Color(1, 1, 0))
		label.add_theme_font_size_override("font_size", 22)
		grid.add_child(label)

	# Current credit entry
	var entry: CreditEntry = credits_data[current_index]

	# 1️⃣ Sprite
	var sprite_node = TextureRect.new()
	sprite_node.texture = entry.sprite
	sprite_node.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	sprite_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite_node.custom_minimum_size = Vector2(128, 128)
	grid.add_child(sprite_node)

	# 2️⃣ License
	var license_label = Label.new()
	license_label.text = entry.license
	license_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	license_label.custom_minimum_size = Vector2(200, 0)  # Set a fixed width
	grid.add_child(license_label)

	# 3️⃣ Creator
	var creator_label = Label.new()
	creator_label.text = entry.creator
	grid.add_child(creator_label)

	# Update button states
	prev_button.disabled = current_index == 0
	next_button.disabled = current_index == credits_data.size() - 1

func _on_next_pressed():
	if current_index < credits_data.size() - 1:
		current_index += 1
		_update_display()

func _on_prev_pressed():
	if current_index > 0:
		current_index -= 1
		_update_display()

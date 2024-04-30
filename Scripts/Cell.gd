class_name Cell

extends Node2D


var _sprite: Sprite2D
var _initial_size_x: float
var _initial_size_y: float
var _coordinates: Coordinates = Coordinates.new(0, 0)
var _occupant: TankPart
var _is_lighted: bool = false
var _current_color: Color = Color.MIDNIGHT_BLUE


func _ready():
	_sprite = get_node("Sprite2D")
	_initial_size_x = _sprite.texture.get_width()
	_initial_size_y = _sprite.texture.get_height()


func _process(delta):
	pass


func set_coordinates(x: int, y: int):
	_coordinates.reset(x, y)


func set_size(size_x: float, size_y: float):
	scale = Vector2(size_x / _initial_size_x, size_y / _initial_size_y)


func light_up():
	_is_lighted = true
	if _current_color == Color.MIDNIGHT_BLUE:
		_sprite.self_modulate = Color.ROYAL_BLUE
	else:
		_sprite.self_modulate = _current_color


func dim():
	if _is_lighted:
		_is_lighted = false
		_sprite.self_modulate = Color.MIDNIGHT_BLUE


func shoot():
	if _occupant == null:
		EventBus.add_message.emit("Missed!")
	else:
		_occupant.try_shoot()


func recolor(color: Color):
	_current_color = color
	if _is_lighted:
		_sprite.self_modulate = _current_color


func occupy(occupant: TankPart):
	_occupant = occupant


func _on_button_button_down():
	EventBus.cell_clicked.emit(_coordinates)

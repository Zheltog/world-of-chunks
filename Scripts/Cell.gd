class_name Cell

extends Node2D


var _sprite: Sprite2D
var _initial_size_x: float
var _initial_size_y: float
var _x: int
var _y: int


func _ready():
	_sprite = get_node("Sprite2D")
	_initial_size_x = _sprite.texture.get_width()
	_initial_size_y = _sprite.texture.get_height()


func _process(delta):
	pass


func set_coordinates(x: int, y: int):
	_x = x
	_y = y


func set_size(size_x: float, size_y: float):
	scale = Vector2(size_x / _initial_size_x, size_y / _initial_size_y)


func light_up():
	_sprite.self_modulate = Color(1, 1, 1, 1)


func shoot():
	_sprite.self_modulate = Color(0, 0, 0, 1)


func _on_button_button_down():
	EventBus.cell_clicked.emit(_x, _y)
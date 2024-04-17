class_name GameController

extends CanvasLayer


@export var cells_num_hor: int
@export var cells_num_ver: int


var _field: Field
var _cell_click_type: CellClickType
var _tank: Tank


enum CellClickType { ROCKET, GUN }


func _ready():
	EventBus.cell_clicked.connect(_on_cell_clicked)
	EventBus.cell_recolored.connect(_on_cell_recolored)
	
	_field = get_node("Field")
	_field.init(cells_num_hor, cells_num_ver)
	_tank = Tank.new()
	_tank.set_coordinates(cells_num_hor - 1, cells_num_ver - 1)


func _process(delta):
	pass


func _on_cell_clicked(coordinates: Coordinates):
	if _cell_click_type == CellClickType.ROCKET:
		_try_light_up_cell(coordinates)
	elif _cell_click_type == CellClickType.GUN:
		_try_shoot_cell(coordinates)
	_try_move_tank()


func _on_cell_recolored(coordinates: Coordinates, color: Color):
	_field.recolor_cell(coordinates, color)


func _try_light_up_cell(coordinates: Coordinates):
	_field.light_up_cell(coordinates)


func _try_shoot_cell(coordinates: Coordinates):
	_field.shoot_cell(coordinates)


func _try_move_tank():
	_tank.try_move()


func _on_check_button_toggled(button_pressed: bool):
	_cell_click_type = CellClickType.GUN if button_pressed else CellClickType.ROCKET

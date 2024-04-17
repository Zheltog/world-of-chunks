class_name GameController

extends CanvasLayer


@export var cells_num_hor: int
@export var cells_num_ver: int


var _field: Field
var _cell_click_type: CellClickType


enum CellClickType { ROCKET, GUN }


func _ready():
	EventBus.cell_clicked.connect(_on_cell_clicked)
	
	_field = get_node("Field")
	_field.init(cells_num_hor, cells_num_ver)


func _process(delta):
	pass


func _on_cell_clicked(x: int, y: int):
	if _cell_click_type == CellClickType.ROCKET:
		_try_light_up_cell(x, y)
	elif _cell_click_type == CellClickType.GUN:
		_try_shoot_cell(x, y)


func _try_light_up_cell(x: int, y: int):
	_field.light_up_cell(x, y)


func _try_shoot_cell(x: int, y: int):
	_field.shoot_cell(x, y)


func _on_check_button_toggled(button_pressed: bool):
	_cell_click_type = CellClickType.GUN if button_pressed else CellClickType.ROCKET

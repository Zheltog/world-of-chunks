class_name GameController

extends CanvasLayer


@export var cells_num_hor: int
@export var cells_num_ver: int
@export var light_up_radius: int = 1
@export var tank_stops_to_win: int = 3


var _field: Field
var _rocket_button: TextureButton
var _gun_button: TextureButton
var _new_button: TextureButton
var _cell_click_type: CellClickType
var _tank: Tank
var _label: Label
var _is_game_over: bool = false
var _current_tank_stops: int = 0


enum CellClickType { ROCKET, GUN }


func _ready():
	EventBus.cell_clicked.connect(_on_cell_clicked)
	EventBus.cell_recolored.connect(_on_cell_recolored)
	EventBus.cell_occupied.connect(_on_cell_occupied)
	EventBus.new_message.connect(_print_new_message)
	EventBus.tank_stopped.connect(_on_tank_stopped)
	EventBus.tank_moved.connect(_on_tank_moved)
	EventBus.tank_escaped.connect(_on_tank_escaped)
	
	_field = get_node("Field")
	_field.init(cells_num_hor, cells_num_ver)
	_tank = Tank.new()
	_tank.set_coordinates(cells_num_hor - 1, cells_num_ver - 1)
	_tank.stop_probability = 25
	_label = get_node("Label")
	
	_init_buttons()
	
	_on_gun_button_pressed()
	_print_new_message("Let's get it!")


func _init_buttons():
	var cell_size: int = _field.get_cell_size()
	var center: Vector2 = _field.get_center()
	
	_rocket_button = get_node("RocketButton")
	_gun_button = get_node("GunButton")
	_new_button = get_node("NewButton")
	_new_button.hide()
	
	var new_init_size_x = _new_button.texture_normal.get_width()
	var new_init_size_y = _new_button.texture_normal.get_height()
	var rocket_init_size_x = _rocket_button.texture_normal.get_width()
	var rocket_init_size_y = _rocket_button.texture_normal.get_height()
	var gun_init_size_x = _gun_button.texture_normal.get_width()
	var gun_init_size_y = _gun_button.texture_normal.get_height()
	
	_new_button.scale = Vector2(cell_size / _new_button.size.x, cell_size / _new_button.size.x)
	_rocket_button.scale = Vector2(cell_size / _rocket_button.size.x, cell_size / _rocket_button.size.y)
	_gun_button.scale = Vector2(cell_size / _gun_button.size.x, cell_size / _gun_button.size.x)


func _process(delta):
	pass


func _on_cell_clicked(coordinates: Coordinates):
	if _is_game_over:
		return
	
	_field._dim_all_cells()
	if _cell_click_type == CellClickType.ROCKET:
		_try_move_tank()
		_try_light_up_cells(coordinates)
	elif _cell_click_type == CellClickType.GUN:
		_try_shoot_cell(coordinates)
		_try_move_tank()


func _on_cell_recolored(coordinates: Coordinates, color: Color):
	_field.recolor_cell(coordinates, color)


func _on_cell_occupied(coordinates: Coordinates, occupant: TankPart):
	_field.occupy_cell(coordinates, occupant)


func _on_tank_stopped():
	_current_tank_stops += 1
	if _current_tank_stops >= tank_stops_to_win:
		_print_new_message(str("Tank stopped ", tank_stops_to_win, " times in a row! Victory!"))
		_on_game_over()


func _on_tank_moved():
	_current_tank_stops = 0


func _on_tank_escaped():
	_print_new_message("Tank escaped! You failed!")
	_on_game_over()


func _try_light_up_cells(center: Coordinates):
	_field.light_up_cells(center, light_up_radius)


func _try_shoot_cell(coordinates: Coordinates):
	_field.shoot_cell(coordinates)


func _try_move_tank():
	_tank.try_move()


func _print_new_message(message: String):
	_label.text = message


func _on_game_over():
	_is_game_over = true
	_rocket_button.hide()
	_gun_button.hide()
	_new_button.show()


func _on_rocket_button_pressed():
	_cell_click_type = CellClickType.ROCKET
	_gun_button.self_modulate = Color.WHITE
	_rocket_button.self_modulate = Color.YELLOW


func _on_gun_button_pressed():
	_cell_click_type = CellClickType.GUN
	_rocket_button.self_modulate = Color.WHITE
	_gun_button.self_modulate = Color.YELLOW


func _on_close_button_pressed():
	get_tree().quit()


func _on_new_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

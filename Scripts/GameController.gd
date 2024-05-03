class_name GameController

extends CanvasLayer


@export var cells_num_hor: int
@export var cells_num_ver: int
@export var light_up_radius: int = 1
@export var tank_stops_to_win: int = 5
@export var tank_initial_stop_probability: int = 36
@export var wheels_stop_probability_modifier: int = 10
@export var body_stop_probability_modifier: int = 3
@export var tower_stop_probability_modifier: int = 7
@export var wheels_hit_probability: int = 50
@export var body_hit_probability: int = 90
@export var tower_hit_probability: int = 70


var _field: Field
var _rocket_button: TextureButton
var _gun_button: TextureButton
var _new_button: TextureButton
var _close_button: TextureButton
var _question_button: TextureButton
var _stop_pic: TextureRect
var _hp_pic: TextureRect
var _cell_click_type: CellClickType
var _tank: Tank
var _main_label: Label
var _stop_label: Label
var _hp_label: Label
var _is_game_over: bool = false
var _current_tank_stops: int = 0


enum CellClickType { ROCKET, GUN }


func _ready():
	EventBus.cell_clicked.connect(_on_cell_clicked)
	EventBus.cell_recolored.connect(_on_cell_recolored)
	EventBus.cell_occupied.connect(_on_cell_occupied)
	EventBus.add_message.connect(_add_message)
	EventBus.tank_stopped.connect(_on_tank_stopped)
	EventBus.tank_moved.connect(_on_tank_moved)
	EventBus.tank_escaped.connect(_on_tank_escaped)
	EventBus.tank_damaged.connect(_on_tank_damaged)
	
	_field = get_node("Field")
	_field.init(cells_num_hor, cells_num_ver)
	_tank = Tank.new()
	_tank.set_coordinates(cells_num_hor - 1, cells_num_ver - 1)
	_tank.stop_probability = tank_initial_stop_probability
	_tank.wheels_stop_probability_modifier = wheels_stop_probability_modifier
	_tank.body_stop_probability_modifier = body_stop_probability_modifier
	_tank.tower_stop_probability_modifier = tower_stop_probability_modifier
	_tank.wheels_hit_probability = wheels_hit_probability
	_tank.body_hit_probability = body_hit_probability
	_tank.tower_hit_probability = tower_hit_probability
	_tank.init()
	
	_init_ui()
	
	_stop_label.text = str(tank_initial_stop_probability, "%")
	_hp_label.text = str(_tank.total_hp())
	
	_on_gun_button_pressed()
	_set_message("Soldier Dulov!\nStop Millennium Tank of general Stool Backless!")


func _init_ui():
	var cell_size: int = _field.get_cell_size()
	var button_size: int = cell_size * 1.5
	var button_size_vector = Vector2(button_size, button_size)
	var center: Vector2 = _field.get_center()
	var screen_sizes: Vector2 = _field.get_screen_sizes()
	
	_question_button = get_node("QuestionButton")
	_close_button = get_node("CloseButton")
	_rocket_button = get_node("RocketButton")
	_gun_button = get_node("GunButton")
	_new_button = get_node("NewButton")
	_main_label = get_node("MainLabel")
	_stop_label = get_node("StopLabel")
	_hp_label = get_node("HpLabel")
	_stop_pic = get_node("StopPic")
	_hp_pic = get_node("HpPic")
	
	_new_button.hide()
	
	_question_button.size = button_size_vector
	_close_button.size = button_size_vector
	_new_button.size = button_size_vector
	_rocket_button.size = button_size_vector
	_gun_button.size = button_size_vector
	_stop_pic.size = button_size_vector
	_hp_pic.size = button_size_vector
	
	_question_button.position = Vector2(cell_size / 4, cell_size / 4)
	_close_button.position = Vector2(screen_sizes.x - button_size - cell_size / 4, cell_size / 4)
	_new_button.position = Vector2(center.x - button_size / 2, screen_sizes.y - button_size - cell_size / 4)
	_rocket_button.position = Vector2(center.x - button_size - cell_size / 8, screen_sizes.y - button_size - cell_size / 4)
	_gun_button.position = Vector2(center.x + cell_size / 8, screen_sizes.y - button_size - cell_size / 4)
	_stop_pic.position = Vector2(cell_size / 4, screen_sizes.y - button_size - cell_size / 4)
	_hp_pic.position = Vector2(screen_sizes.x - button_size - cell_size / 4, screen_sizes.y - button_size - cell_size / 4)
	
	_main_label.position = Vector2(_main_label.position.x, cell_size / 4)
	_main_label.add_theme_font_size_override("font_size", cell_size / 2)
	_stop_label.position = Vector2(_stop_pic.position.x + button_size + cell_size / 4, _stop_pic.position.y)
	_stop_label.add_theme_font_size_override("font_size", cell_size)
	_hp_label.position = Vector2(_hp_pic.position.x - _hp_label.size.x - cell_size / 4, _hp_pic.position.y)
	_hp_label.add_theme_font_size_override("font_size", cell_size)


func _process(delta):
	pass


func _on_cell_clicked(coordinates: Coordinates):
	if _is_game_over:
		return
	
	_reset_message()
	_field._dim_all_cells()
	if _cell_click_type == CellClickType.ROCKET:
		_try_move_tank()
		if not _is_game_over:
			_try_light_up_cells(coordinates)
	elif _cell_click_type == CellClickType.GUN:
		_try_shoot_cell(coordinates)
		_try_move_tank()
	
	_stop_label.text = str(_tank.stop_probability, "%")


func _on_cell_recolored(coordinates: Coordinates, color: Color):
	_field.recolor_cell(coordinates, color)


func _on_cell_occupied(coordinates: Coordinates, occupant: TankPart):
	_field.occupy_cell(coordinates, occupant)


func _on_tank_stopped():
	_current_tank_stops += 1
	if _current_tank_stops >= tank_stops_to_win:
		_set_message(str("Tank stopped ", tank_stops_to_win, " times in a row! Victory!"))
		_on_game_over()


func _on_tank_moved():
	_current_tank_stops = 0


func _on_tank_escaped():
	_set_message("Tank escaped! You failed!")
	_on_game_over()


func _on_tank_damaged(remaining_hp: int):
	_hp_label.text = str(remaining_hp)
	if remaining_hp <= 0:
		_set_message("Tank is destroyed! Victory!")
		_on_game_over()


func _try_light_up_cells(center: Coordinates):
	_add_message("Field is lighted up!")
	_field.light_up_cells(center, light_up_radius)


func _try_shoot_cell(coordinates: Coordinates):
	_field.shoot_cell(coordinates)


func _try_move_tank():
	_tank.try_move()


func _reset_message():
	_main_label.text = ""


func _set_message(message: String):
	_main_label.text = message


func _add_message(message: String):
	if _main_label.text == "":
		_set_message(message)
	else:
		_main_label.text += "\n" + message


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


func _on_question_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/info.tscn")

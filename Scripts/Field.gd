class_name Field

extends Node2D


var _cells_num_hor: int
var _cells_num_ver: int
var _cell_size: int
var _center: Vector2
var _cells: Array
var _cell_scene: PackedScene = load("res://Scenes/cell.tscn")


func _ready():
	pass


func _process(delta):
	pass


func init(cells_num_hor: int, cells_num_ver: int):
	_cells_num_hor = cells_num_hor
	_cells_num_ver = cells_num_ver
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	_center = Vector2(screen_width / 2, screen_height / 2)
	_cell_size = min(screen_width / (_cells_num_hor + 2), screen_height / (_cells_num_ver + 2))
	_init_cells()


func get_center() -> Vector2:
	return _center


func get_cell_size() -> int:
	return _cell_size


func light_up_cells(center: Coordinates, light_up_radius: int):
	for delta_x in range(-light_up_radius, light_up_radius + 1):
		for delta_y in range(-light_up_radius, light_up_radius + 1):
			var coordinates = Coordinates.new(center.x + delta_x, center.y + delta_y)
			if coordinates.x < 0 or coordinates.x >= _cells_num_hor:
				continue
			if coordinates.y < 0 or coordinates.y >= _cells_num_ver:
				continue
			_cells[coordinates.y * _cells_num_hor + coordinates.x].light_up()


func shoot_cell(coordinates: Coordinates):
	_cells[coordinates.y * _cells_num_hor + coordinates.x].shoot()


func recolor_cell(coordinates: Coordinates, color: Color):
	_cells[coordinates.y * _cells_num_hor + coordinates.x].recolor(color)


func occupy_cell(coordinates: Coordinates, occupant: TankPart):
	_cells[coordinates.y * _cells_num_hor + coordinates.x].occupy(occupant)


func _init_cells():
	if _cells.size() > 0:
		_destroy_old_cells()
	
	_cells.clear()
	_cells.resize(_cells_num_hor * _cells_num_ver)
	
	var left_top_x = _center.x - (_cells_num_hor * _cell_size / 2)
	var left_top_y = _center.y - (_cells_num_ver * _cell_size / 2)
	var init_pos_x = left_top_x + _cell_size / 2
	var init_pos_y = left_top_y + _cell_size / 2
	
	for y in range(_cells_num_ver):
		for x in range(_cells_num_hor):
			var cell: Cell = _cell_scene.instantiate()
			add_child(cell)
			cell.set_size(_cell_size, _cell_size)
			cell.set_coordinates(x, y)
			cell.name = str("Cell[", x, ",", y, "]")
			cell.position = Vector2(init_pos_x + x * _cell_size, init_pos_y + y * _cell_size)
			_cells[y * _cells_num_hor + x] = cell


func _dim_all_cells():
	for cell in _cells:
		cell.dim()


func _destroy_old_cells():
	for cell in _cells:
		cell.queue_free()

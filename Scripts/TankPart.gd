class_name TankPart

extends Node


var parent: Tank
var relative_coordinates: Array
var color: Color
var hp: int
var hit_probability: int
var stop_probability_modifier: int
var part_name: String


func _ready():
	pass


func _process(delta):
	pass


func release_cells():
	_process_coordinates(Color.MIDNIGHT_BLUE, null)


func ocuppy_cells():
	_process_coordinates(color, self)


func try_shoot():
	if hp == 0:
		return
	
	var random = randi() % 100
	
	var is_hit = random < hit_probability
	
	if is_hit:
		hp -= 1
		EventBus.new_message.emit(str("Got it! Remaining ", hp, " of ", part_name))
		parent.on_hit(stop_probability_modifier)
		if hp == 0:
			color = Color.DIM_GRAY
	else:
		EventBus.new_message.emit("Missed!")


func _process_coordinates(_color: Color, _occupant: TankPart):
	for coordinates in relative_coordinates:
		var actual = _calc_actual_coordinates(coordinates)
		EventBus.cell_recolored.emit(actual, _color)
		EventBus.cell_occupied.emit(actual, _occupant)


func _calc_actual_coordinates(relative: Coordinates) -> Coordinates:
	var actual: Coordinates = Coordinates.new(0, 0)
	actual.x = parent.base_coordinates.x + relative.x
	actual.y = parent.base_coordinates.y + relative.y
	return actual

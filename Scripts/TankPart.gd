class_name TankPart

extends Node


var parent: Tank
var relative_coordinates: Array
var color: Color
var black: Color = Color.BLACK
var hp: int
var hit_probability: int
var part_name: String


func _ready():
	pass


func _process(delta):
	pass


func reset():
	for coordinates in relative_coordinates:
		var actual = _calc_actual_coordinates(coordinates)
		EventBus.cell_recolored.emit(actual, black)
		EventBus.cell_occupied.emit(actual, null)


func update():
	for coordinates in relative_coordinates:
		var actual = _calc_actual_coordinates(coordinates)
		EventBus.cell_recolored.emit(actual, color)
		EventBus.cell_occupied.emit(actual, self)


func try_shoot():
	var random = randi() % 100
	var is_hit = random < hit_probability
	if is_hit:
		hp -= 1
		EventBus.new_message.emit(str("Got it! Remaining ", hp, " of ", part_name))
	else:
		EventBus.new_message.emit("Missed!!!")


func _calc_actual_coordinates(relative: Coordinates) -> Coordinates:
	var actual: Coordinates = Coordinates.new(0, 0)
	actual.x = parent.coordinates.x + relative.x
	actual.y = parent.coordinates.y + relative.y
	return actual

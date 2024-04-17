class_name TankPart

extends Node


var parent: Tank
var relative_coordinates: Array
var color: Color


func _ready():
	pass


func _process(delta):
	pass


func set_color(color: Color):
	for coordinates in relative_coordinates:
		EventBus.cell_recolored.emit(_calc_actual_coordinates(coordinates), color)


func _calc_actual_coordinates(relative: Coordinates) -> Coordinates:
	var actual: Coordinates = Coordinates.new(0, 0)
	actual.x = parent.coordinates.x + relative.x
	actual.y = parent.coordinates.y + relative.y
	return actual

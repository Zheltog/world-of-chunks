class_name Tank

extends Node


var _tower: TankPart = TankPart.new()
var _body: TankPart = TankPart.new()
var _wheels: TankPart = TankPart.new()

var coordinates: Coordinates = Coordinates.new(0, 0)


func _init():
	_wheels.relative_coordinates.resize(3)
	_wheels.relative_coordinates[0] = Coordinates.new(0, 0)
	_wheels.relative_coordinates[1] = Coordinates.new(-1, 0)
	_wheels.relative_coordinates[2] = Coordinates.new(-2, 0)
	_wheels.color = Color(1, 0, 0, 1)
	_wheels.parent = self
	_body.relative_coordinates.resize(2)
	_body.relative_coordinates[0] = Coordinates.new(0, -1)
	_body.relative_coordinates[1] = Coordinates.new(-1, -1)
	_body.color = Color(1, 1, 0, 1)
	_body.parent = self
	_tower.relative_coordinates.resize(4)
	_tower.relative_coordinates[0] = Coordinates.new(0, -2)
	_tower.relative_coordinates[1] = Coordinates.new(-1, -2)
	_tower.relative_coordinates[2] = Coordinates.new(-2, -2)
	_tower.relative_coordinates[3] = Coordinates.new(0, -3)
	_tower.color = Color(0, 1, 0, 1)
	_tower.parent = self


func _ready():
	pass


func _process(delta):
	pass


func try_move():
	_wheels.set_color(Color(1, 1, 1, 1))
	_body.set_color(Color(1, 1, 1, 1))
	_tower.set_color(Color(1, 1, 1, 1))
	coordinates.move(-1, 0)
	_wheels.set_color(_wheels.color)
	_body.set_color(_body.color)
	_tower.set_color(_tower.color)


func set_coordinates(x: int, y: int):
	coordinates.reset(x, y)

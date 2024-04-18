class_name Tank

extends Node


var _tower: TankPart = TankPart.new()
var _body: TankPart = TankPart.new()
var _wheels: TankPart = TankPart.new()

var stop_probability: int
var coordinates: Coordinates = Coordinates.new(0, 0)


func _init():
	_wheels.relative_coordinates.resize(3)
	_wheels.relative_coordinates[0] = Coordinates.new(0, 0)
	_wheels.relative_coordinates[1] = Coordinates.new(-1, 0)
	_wheels.relative_coordinates[2] = Coordinates.new(-2, 0)
	_wheels.color = Color.RED
	_wheels.parent = self
	_wheels.hp = 4
	_wheels.hit_probability = 25
	_wheels.part_name = "wheels"
	_body.relative_coordinates.resize(2)
	_body.relative_coordinates[0] = Coordinates.new(0, -1)
	_body.relative_coordinates[1] = Coordinates.new(-1, -1)
	_body.color = Color.GREEN
	_body.parent = self
	_body.hp = 6
	_body.hit_probability = 75
	_body.part_name = "body"
	_tower.relative_coordinates.resize(4)
	_tower.relative_coordinates[0] = Coordinates.new(0, -2)
	_tower.relative_coordinates[1] = Coordinates.new(-1, -2)
	_tower.relative_coordinates[2] = Coordinates.new(-2, -2)
	_tower.relative_coordinates[3] = Coordinates.new(0, -3)
	_tower.color = Color.YELLOW
	_tower.parent = self
	_tower.hp = 5
	_tower.hit_probability = 50
	_tower.part_name = "tower"


func _ready():
	pass


func _process(delta):
	pass


func try_move():
	var random = randi() % 100
	var is_stop = random < stop_probability
	if is_stop:
		EventBus.new_message.emit("Bruh...")
		return
	
	_wheels.reset()
	_body.reset()
	_tower.reset()
	coordinates.move(-1, 0)
	_wheels.update()
	_body.update()
	_tower.update()


func set_coordinates(x: int, y: int):
	coordinates.reset(x, y)

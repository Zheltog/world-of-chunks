class_name Tank

extends Node


var _tower: TankPart = TankPart.new()
var _body: TankPart = TankPart.new()
var _wheels: TankPart = TankPart.new()

var stop_probability: int
var base_coordinates: Coordinates = Coordinates.new(0, 0)


func _init():
	_init_tower()
	_init_body()
	_init_wheels()


func _ready():
	pass


func _process(delta):
	pass


func try_move():
	var random = randi() % 100
	var is_stop = random < stop_probability
	if is_stop:
		EventBus.new_message.emit("Bruh...")
		EventBus.tank_stopped.emit()
	else:
		_move()


func set_coordinates(x: int, y: int):
	base_coordinates.reset(x, y)


func _move():
	EventBus.tank_moved.emit()
	
	_wheels.release_cells()
	_body.release_cells()
	_tower.release_cells()
	
	base_coordinates.move(-1, 0)
	if base_coordinates.x < 0:
		EventBus.tank_escaped.emit()
	
	_wheels.ocuppy_cells()
	_body.ocuppy_cells()
	_tower.ocuppy_cells()


func _init_tower():
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


func _init_body():
	_body.relative_coordinates.resize(2)
	_body.relative_coordinates[0] = Coordinates.new(0, -1)
	_body.relative_coordinates[1] = Coordinates.new(-1, -1)
	_body.color = Color.GREEN
	_body.parent = self
	_body.hp = 6
	_body.hit_probability = 75
	_body.part_name = "body"


func _init_wheels():
	_wheels.relative_coordinates.resize(3)
	_wheels.relative_coordinates[0] = Coordinates.new(0, 0)
	_wheels.relative_coordinates[1] = Coordinates.new(-1, 0)
	_wheels.relative_coordinates[2] = Coordinates.new(-2, 0)
	_wheels.color = Color.RED
	_wheels.parent = self
	_wheels.hp = 4
	_wheels.hit_probability = 25
	_wheels.part_name = "wheels"

class_name Tank

extends Node


var _tower: TankPart = TankPart.new()
var _body: TankPart = TankPart.new()
var _wheels: TankPart = TankPart.new()

var stop_probability: int
var base_coordinates: Coordinates = Coordinates.new(0, 0)
var wheels_stop_probability_modifier: int
var body_stop_probability_modifier: int
var tower_stop_probability_modifier: int
var wheels_hit_probability: int
var body_hit_probability: int
var tower_hit_probability: int


func init():
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
	_move(0 if is_stop else -1)


func set_coordinates(x: int, y: int):
	base_coordinates.reset(x, y)


func on_hit(stop_probability_modifier: int):
	stop_probability += stop_probability_modifier
	var remaining_hp = _wheels.hp + _body.hp + _tower.hp
	EventBus.tank_damaged.emit(remaining_hp)


func total_hp() -> int:
	return _tower.hp + _body.hp + _wheels.hp


func _move(distance: int):
	if distance == 0:
		EventBus.add_message.emit(str("Tank stopped (", stop_probability, "%)!"))
		EventBus.tank_stopped.emit()
	else:
		EventBus.add_message.emit(str("Tank moved (", 100 - stop_probability, "%)!"))
		EventBus.tank_moved.emit()
	
	_wheels.release_cells()
	_body.release_cells()
	_tower.release_cells()
	
	base_coordinates.move(distance, 0)
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
	_tower.hp = _tower.relative_coordinates.size()
	_tower.hit_probability = tower_hit_probability
	_tower.stop_probability_modifier = tower_stop_probability_modifier
	_tower.part_name = "tower"


func _init_body():
	_body.relative_coordinates.resize(2)
	_body.relative_coordinates[0] = Coordinates.new(0, -1)
	_body.relative_coordinates[1] = Coordinates.new(-1, -1)
	_body.color = Color.GREEN
	_body.parent = self
	_body.hp = _body.relative_coordinates.size()
	_body.hit_probability = body_hit_probability
	_body.stop_probability_modifier = body_stop_probability_modifier
	_body.part_name = "body"


func _init_wheels():
	_wheels.relative_coordinates.resize(3)
	_wheels.relative_coordinates[0] = Coordinates.new(0, 0)
	_wheels.relative_coordinates[1] = Coordinates.new(-1, 0)
	_wheels.relative_coordinates[2] = Coordinates.new(-2, 0)
	_wheels.color = Color.RED
	_wheels.parent = self
	_wheels.hp = _wheels.relative_coordinates.size()
	_wheels.hit_probability = wheels_hit_probability
	_wheels.stop_probability_modifier = wheels_stop_probability_modifier
	_wheels.part_name = "wheels"

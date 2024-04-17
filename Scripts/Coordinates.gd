class_name Coordinates

extends Node


var x: int
var y: int


func _init(_x: int, _y: int):
	reset(_x, _y)


func reset(_x: int, _y: int):
	x = _x
	y = _y


func move(_delta_x: int, _delta_y: int):
	x += _delta_x
	y += _delta_y

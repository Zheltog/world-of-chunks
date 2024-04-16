class_name GameController

extends CanvasLayer


@export var cells_num_hor: int
@export var cells_num_ver: int


var _field: Field


func _ready():
	_field = get_node("Field")
	_field.init(cells_num_hor, cells_num_ver)


func _process(delta):
	pass

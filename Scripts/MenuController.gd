class_name MenuController

extends CanvasLayer


func _ready():
	pass


func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_story_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/backstory.tscn")


func _on_question_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/tips.tscn")


func _on_close_button_pressed():
	get_tree().quit()

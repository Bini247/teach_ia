extends Control

var current_speed = 1

func _ready():
	$VBoxContainer2/TextureButton/Speed.text = "Speed: " + str(current_speed) + "x"
	
func _on_TextureButton_pressed():
	
	current_speed += 1
	
	if current_speed == 5: current_speed = 1
	
	get_parent().get_parent().set_speed_mode(current_speed)
	$VBoxContainer2/TextureButton/Speed.text = "Speed: " + str(current_speed) + "x"

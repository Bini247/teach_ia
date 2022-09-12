extends Control

var current_speed = 1

var time = 0

func _process(delta):
	time += delta
	
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	var hrs  = fmod((fmod(time, 3600 * 60) / 3600), 24)
	
	var time_passed = "%02d : %02d : %02d" % [hrs, mins, secs]
	$Timer.text = time_passed

func _ready():
	$VBoxContainer2/TextureButton/Speed.text = "Speed: " + str(current_speed) + "x"
	
func _on_TextureButton_pressed():
	
	current_speed += 1
	
	if current_speed == 5: current_speed = 1
	
	get_parent().get_parent().set_speed_mode(current_speed)
	$VBoxContainer2/TextureButton/Speed.text = "Speed: " + str(current_speed) + "x"

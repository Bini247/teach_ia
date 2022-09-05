extends TextureRect

var clicked = false
var clicked_preview = false

func _on_ObjectSlot_gui_input(event):
	if clicked: return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed: 
			var data = {}
			data['origin_node'] = self
			data["origin_texture"] = texture

			var drag_texture = TextureRect.new()
			drag_texture.expand = true
			drag_texture.texture = texture
			drag_texture.rect_size = Vector2(32, 32)
			
			var control = Control.new()
			control.add_child(drag_texture)
			drag_texture.rect_position = get_viewport().get_mouse_position()
			clicked_preview = drag_texture
			get_parent().add_child(control)
			clicked = true

func _physics_process(delta):
	if clicked: clicked_preview.rect_position = get_viewport().get_mouse_position()

func _input(event):
	if (event.is_action_pressed("ui_cancel") || event.is_action_pressed("right_click")) && clicked:
		clicked = false
		clicked_preview.queue_free()

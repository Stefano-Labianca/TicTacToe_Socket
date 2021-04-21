extends Control

var main_menu_node: Control

func _ready() -> void:
	main_menu_node = get_tree().get_root().get_node("Game/MainMenu")

func _on_Back_pressed() -> void:
	var sound: AudioStreamPlayer2D = main_menu_node.call("create_audio_stream", $Back.rect_position)

	get_parent().add_child(sound)
	sound.play(0)

	main_menu_node.visible = true
	self.visible = false

extends Control

const DIFFICULTY_LEVEL: Dictionary = {"Easy": 1, "Medium": 2, "Hard": 3}
var main_menu_node: Control
var board_node: Node2D

func _ready() -> void:
	main_menu_node = get_tree().get_root().get_node("Game/MainMenu")
	board_node = get_tree().get_root().get_node("Game/Board")


# Funzione richiamata quando il segnale "pressed" viene invocato
func _on_Back_pressed() -> void:
	var sound: AudioStreamPlayer2D = main_menu_node.call("create_audio_stream", $Back.rect_position)

	get_parent().add_child(sound)
	sound.play(0)

	main_menu_node.visible = true
	self.visible = false


# Funzione richiamata quando il segnale "pressed" viene invocato
# premendo il bottone che indica la difficoltà facile
func _on_Easy_pressed() -> void:
	var sound: AudioStreamPlayer2D = main_menu_node.call("create_audio_stream", $Easy.rect_position)
	get_parent().add_child(sound)
	sound.play(0)

	_set_game_difficulty(DIFFICULTY_LEVEL.Easy)
	_show_game_board()


# Funzione richiamata quando il segnale "pressed" viene invocato
# premendo il bottone che indica la difficoltà media
func _on_Medium_pressed() -> void:
	var sound: AudioStreamPlayer2D = main_menu_node.call("create_audio_stream", $Medium.rect_position)
	get_parent().add_child(sound)
	sound.play(0)

	_set_game_difficulty(DIFFICULTY_LEVEL.Medium)
	_show_game_board()


# Funzione richiamata quando il segnale "pressed" viene invocato
# premendo il bottone che indica la difficoltà difficile
func _on_Hard_pressed() -> void:
	var sound: AudioStreamPlayer2D = main_menu_node.call("create_audio_stream", $Hard.rect_position)
	get_parent().add_child(sound)
	sound.play(0)

	_set_game_difficulty(DIFFICULTY_LEVEL.Hard)
	_show_game_board()


# Funzione usata per impostare la difficoltà di gioco.
#
# @params lvl: int --> livello di difficoltà
func _set_game_difficulty(lvl: int):
	get_parent().difficulty = lvl
	print("Difficoltà: ", get_parent().difficulty)


# Funzione usata per mostrare la griglia di gioco
func _show_game_board() -> void:
	board_node.visible = true
	self.visible = false

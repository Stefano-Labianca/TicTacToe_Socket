extends Control

const AUDIO_VOLUME: float = 7.5
var sound: AudioStreamPlayer2D


# Segnale richiamato quando si preme sul bottone "Quit"
func _on_Quit_pressed() -> void:
	get_tree().quit() # Chiude il gioco


# Segnale richiamato quando si preme il bottone "Singleplayer"
func _on_Singleplayer_pressed() -> void:
	sound = create_audio_stream($Singleplayer.rect_position)
	get_parent().add_child(sound)
	sound.play(0)

	var choose_difficulty_node: Control = get_tree().get_root().get_node("Game/ChooseDifficulty")
	var clickable_pos: Node2D = get_tree().get_root().get_node("Game/Board/Clickable")
	var grid_pos: Sprite = get_tree().get_root().get_node("Game/Board/Grid")

	if clickable_pos.position != Vector2(0, 0):
		grid_pos.position -= clickable_pos.position
		clickable_pos.position = Vector2(0, 0)

	choose_difficulty_node.visible = true
	self.visible = false


# Segnale richiamato quando si preme il bottone "Multiplayer"
func _on_Multiplayer_pressed() -> void:
	sound = create_audio_stream($Multiplayer.rect_position)
	get_parent().add_child(sound)
	sound.play(0)

	get_parent().difficulty = 0
	var clickable_pos: Node2D = get_tree().get_root().get_node("Game/Board/Clickable")
	var grid_pos: Sprite = get_tree().get_root().get_node("Game/Board/Grid")

	if clickable_pos.position == Vector2(0, 0):
		clickable_pos.position = Vector2(424, 0)
		grid_pos.position += clickable_pos.position

	var multyplayer_node: Node = get_tree().get_root().get_node("Game/Multiplayer")
	multyplayer_node.call("start_multiplayer") # Chiamo il metodo 'start_multiplayer' per stabilire una sessione multiplayer
	$GameMessagge.text = "in attesa della connessione al server..."


# Funzione usata per creare un oggetto di tipo AudioStreamPlayer2D contenente
# la traccia audio del suono di selezione di un bottone.
#
# @params button_position: Vector2 --> Posizione del bottone all'interno della scena
#
# @returns AudioStreamPlayer2D --> Oggetto che rappresenta la traccia audio 2D creata
func create_audio_stream(button_position: Vector2) -> AudioStreamPlayer2D:
	var bip_sound: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	var list_of_sounds: Array = get_tree().get_nodes_in_group("bip") # Prendo tutti i nodi che fanno parte del gruppo "bip"

	if list_of_sounds.size() == 0:
		bip_sound = _get_audio_stream(bip_sound, button_position)
	else:
		for audio in list_of_sounds:
			audio.queue_free()
		bip_sound = _get_audio_stream(bip_sound, button_position)

	return bip_sound


# Funzione usata per creare lo stream audio
#
# @params button_position: Vector2 --> Posizione del bottone all'interno della scena
# @params bip_sound: AudioStreamPlayer2D --> Classe usata per creare una traccia audio 2D
#
# @returns AudioStreamPlayer2D --> Oggetto che rappresenta la traccia audio 2D creata
func _get_audio_stream(bip_sound: AudioStreamPlayer2D, button_position: Vector2) -> AudioStreamPlayer2D:
	bip_sound.stream = load("res://assets/audio/Blip_Select.wav")
	bip_sound.volume_db = AUDIO_VOLUME
	bip_sound.position = button_position
	bip_sound.add_to_group("bip")

	return bip_sound


# Funzione chiamata dopo lo scadere del tempo del nodo 'Timer'
func _on_Timer_timeout() -> void:
	$GameMessagge.visible = false
	$GameMessagge.text = ""


# Funzione richiamata quando viene premuto il pulsante per accedere alle impostazioni di gioco
func _on_Controls_pressed() -> void:
	sound = create_audio_stream($Controls.rect_position)
	get_parent().add_child(sound)
	sound.play(0)

	var settings: Control = get_tree().get_root().get_node("Game/ControlsWin")
	settings.visible = true
	self.visible = false

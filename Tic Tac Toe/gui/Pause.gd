extends CanvasLayer

var game_node: Node
var board_node: Node2D
var winning_node: Control
var menu_node: Control

var multiplayer_node: Node
var online_board: Node


func _ready() -> void:
	game_node = get_tree().get_root().get_node("Game")
	board_node = get_tree().get_root().get_node("Game/Board")
	winning_node = get_tree().get_root().get_node("Game/Winner")
	menu_node = get_tree().get_root().get_node("Game/MainMenu")

	multiplayer_node = get_tree().get_root().get_node("Game/Multiplayer")
	online_board = get_tree().get_root().get_node("Game/Multiplayer/OnlineBoard")

	_set_visible(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Vera se premuto il tasto ESC

		if not winning_node.visible and board_node.visible: # Verifico se il nodo del vincitore non è visibile ma è visibile quello della griglia
			_set_visible(!get_tree().paused) # Imposto la visibilità della schermata di pausa a true
			get_tree().paused = !get_tree().paused


# Funzione usata per modificare la visibilità di tutti i nodi della scena 'Pause'.
# Se al paramentro 'is_visible' viene assegnato il valore false, tutti i nodi saranno
# invisibili, altrimenti se li viene assegnato true i nodi saranno visibili.
#
# @params is_visible: bool --> Modifica la visibilità dei nodi.
func _set_visible(is_visible: bool) -> void:
	for node in get_children():
		node.visible = is_visible


# Funzione richiamata quando il bottone 'Continue' viene premuto.
# Una volta premuto elimina lo stato di pausa del gioco.
func _on_Continue_pressed() -> void:
	var sound: AudioStreamPlayer2D = menu_node.callv("create_audio_stream", [$Continue.rect_position])

	get_tree().paused = false
	get_parent().add_child(sound)
	sound.play(0)
	_set_visible(false)


# Funzione richimata quando il bottone 'GiveUp' viene premuto.
# Una volta premuto farà uscire il giocatore dalla partita, portandolo
# al menù di gioco.
func _on_GiveUp_pressed() -> void:
	var sound: AudioStreamPlayer2D = menu_node.callv("create_audio_stream", [$GiveUp.rect_position])

	get_tree().paused = false
	_set_visible(false)

	if online_board.call("get_sprite") != "":
		var socket: WebSocketClient = multiplayer_node.call("get_web_socket")

		multiplayer_node.call("disconnect_multiplayer_signals")
		socket.disconnect_from_host(1000, "giveup")

	board_node.visible = false
	game_node.call("clear_game") # Ricreo la sessione di gioco
	menu_node.visible = true

	get_parent().add_child(sound)
	sound.play(0)

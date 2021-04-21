extends Node2D

export(Texture) var o_texture
export(Texture) var x_texture

const SCALE_PLUS: Vector2 = Vector2(2.5, 2.5)
const CLICK_AREA_AUDIO: float = 2.5

var cells_positions: Dictionary
var cells_names: Dictionary

var ai_node_manager: Node
var game_node: Node
var multiplayer_node: Node
var online_board: Node

var ai_sprite_position: Vector2
var has_sprite: bool = false


func _ready() -> void:
	ai_node_manager = get_parent().get_node("AIManager")
	multiplayer_node = get_parent().get_node("Multiplayer")
	online_board = get_parent().get_node("Multiplayer/OnlineBoard")





	game_node = get_parent()
	cells_positions = {
		Vector2(0, 0): $Clickable/Spot1.position,
		Vector2(1, 0): $Clickable/Spot2.position,
		Vector2(2, 0): $Clickable/Spot3.position,

		Vector2(0, 1): $Clickable/Spot4.position,
		Vector2(1, 1): $Clickable/Spot5.position,
		Vector2(2, 1): $Clickable/Spot6.position,

		Vector2(0, 2): $Clickable/Spot7.position,
		Vector2(1, 2): $Clickable/Spot8.position,
		Vector2(2, 2): $Clickable/Spot9.position
	}

	cells_names = {
		Vector2(0, 0): $Clickable/Spot1.name,
		Vector2(1, 0): $Clickable/Spot2.name,
		Vector2(2, 0): $Clickable/Spot3.name,

		Vector2(0, 1): $Clickable/Spot4.name,
		Vector2(1, 1): $Clickable/Spot5.name,
		Vector2(2, 1): $Clickable/Spot6.name,

		Vector2(0, 2): $Clickable/Spot7.name,
		Vector2(1, 2): $Clickable/Spot8.name,
		Vector2(2, 2): $Clickable/Spot9.name,
	}


# ------------------------------------------------------------ #
# Funzioni usate per ascoltare gli eventi di input dell'utente #
# sui nodi di tipo Area2D.                                     #
func _on_Spot_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot1.position, $Clickable/Spot1.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot1.position, $Clickable/Spot1.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot1.position, $Clickable/Spot1.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot1.position)


func _on_Spot2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot2.position, $Clickable/Spot2.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot2.position, $Clickable/Spot2.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot2.position, $Clickable/Spot2.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot2.position)


func _on_Spot3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot3.position, $Clickable/Spot3.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot3.position, $Clickable/Spot3.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot3.position, $Clickable/Spot3.name, online_board.turno)
					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot3.position)


func _on_Spot4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot4.position, $Clickable/Spot4.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot4.position, $Clickable/Spot4.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot4.position, $Clickable/Spot4.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot4.position)


func _on_Spot5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot5.position, $Clickable/Spot5.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot5.position, $Clickable/Spot5.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot5.position, $Clickable/Spot5.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot5.position)


func _on_Spot6_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot6.position, $Clickable/Spot6.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot6.position, $Clickable/Spot6.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot6.position, $Clickable/Spot6.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot6.position)


func _on_Spot7_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot7.position, $Clickable/Spot7.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot7.position, $Clickable/Spot7.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot7.position, $Clickable/Spot7.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot7.position)


func _on_Spot8_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot8.position, $Clickable/Spot8.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot8.position, $Clickable/Spot8.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot8.position, $Clickable/Spot8.name, online_board.turno)

					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot8.position)


func _on_Spot9_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if (not has_sprite) and (not game_node.call("has_last_empty_cell")):
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					_draw_board($Clickable/Spot9.position, $Clickable/Spot9.name)
				else:
					# MULTIPLAYER
					if (online_board.turno % 2 == ai_node_manager.PLAYER_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.X_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot9.position, $Clickable/Spot9.name, online_board.turno)

					elif (online_board.turno % 2 == ai_node_manager.AI_VALUE) and (online_board.player_sprite == online_board.SPRITE_DICT.O_S):
						online_board.turno += 1
						_multiplayer_board($Clickable/Spot9.position, $Clickable/Spot9.name, online_board.turno)
					else:
						print("Non è il tuo turno")
			else:
				has_sprite = false

			_create_click_audio($Clickable/Spot9.position)

# ------------------------------------------------------------ #


# Funzione usata per disegnare gli sprite nelle aree scelte dal giocatore
#
# @params area_position: Vector2 --> Posizione Area2D selezionata
# @params area_name: String --> Nome Area2D selezionata
func _draw_board(area_position: Vector2, area_name: String) -> void:
	var is_created: bool = _generate_player_sprite(area_position, area_name)

	if is_created:
		game_node.callv("update_board", [cells_positions, area_position, "Player"])

		var winner: Array = game_node.call("is_winner")

		if (not winner[0]) and (winner[1] != "Player"):
			while true:
				if get_parent().difficulty > ai_node_manager.PLAYER_VALUE:
					ai_sprite_position = ai_node_manager.call("ai_move")

					if not game_node.call("has_last_empty_cell"):
						if not game_node.callv("is_cell_full", [ai_sprite_position]):

							generate_ai_sprite(ai_sprite_position)
							game_node.callv("update_board", [cells_positions, ai_sprite_position, "AI"])

							winner = game_node.call("is_winner")
							if (winner[0]) and (winner[1] == "AI"):
								game_node.callv("show_winner", [winner[1]]) # Sconfitta

							break
					else:
						game_node.callv("show_winner", [winner[1]]) # Pareggio
						break

				else:
					break
		else:
			game_node.callv("show_winner", [winner[1]]) # Vittoria
	else:
		has_sprite = not has_sprite


# Funzione usata per generare e mostrare nella scena lo sprite del giocatore.
# Resituisce true se lo sprite è stato creato con  successo, altrimenti false.
#
# @params spot_position: Vector2 --> Posizione dell'Area2D all'interno della scena
# @params spot_name: String --> Nome dell'Area2D premuta
#
# @params bool --> Esito creazione dello sprite.
func _generate_player_sprite(spot_position: Vector2, spot_name: String) -> bool:
	var o_texture_list: Array = get_tree().get_nodes_in_group("o_texture_group")
	var x_texture_list: Array = get_tree().get_nodes_in_group("x_texture_group")
	var sprite: Sprite = Sprite.new()
	var sprite_not_found: bool = true

	if o_texture_list.size() > 0 and x_texture_list.size() > 0:
		if _find_node_name(o_texture_list, spot_name):
			if _find_node_name(x_texture_list, spot_name):
				sprite = _insert_player_sprite(sprite, spot_position, spot_name)
				add_child(sprite)
			else:
				sprite_not_found = not sprite_not_found
		else:
			sprite_not_found = not sprite_not_found

	elif o_texture_list.size() == 0 and x_texture_list.size() == 0:
		sprite = _insert_player_sprite(sprite, spot_position, spot_name)
		add_child(sprite)

	return sprite_not_found


# Funzione usata per controllare l'esistenza di Sprite, inseriti nella
# griglia dall'utente, in una certa posizione. Restituisce false se uno
# sprite possiede il nome indicato in spot_name, altrimenti true.
#
# @params list_of_texture: Array --> Contiene tutti gli sprite dell'utente
# @params spot_name: String --> Nome dell'Area2D da ricercare
#
# @returns bool --> Esito della ricerca
func _find_node_name(list_of_texture: Array, spot_name: String) -> bool:
	var regex: RegEx = RegEx.new()

	for sprite in list_of_texture:
		if regex.compile(spot_name) == OK:
			if regex.search(sprite.name):
				has_sprite = true
				return false
	return true


# Funzione usata per creare ed inserire il nodo di tipo Sprite all'interno della
# tabella di gioco.
#
# @params sprite: Sprite --> Sprite da inserire
# @params spot_position: Vector2 --> Posizione dell'Area2D all'interno della scena
# @params spot_name: String --> Posizione dell'Area2D all'interno della scena
func _insert_player_sprite(sprite: Sprite, spot_position: Vector2, spot_name: String) -> Sprite:
	sprite.texture = x_texture # Assegno la texture al nodo Sprite
	sprite.visible = true
	sprite.scale = SCALE_PLUS # Aumento le dimensioni dello sprite di un fattore 2.5 per l'asse x e y
	sprite.position = spot_position + $Clickable.position

	sprite.name = spot_name
	sprite.add_to_group("x_texture_group")

	return sprite


# Funzione usata per mostrare a video lo sprite dell'AI. Il parametro 'relative_position' è di
# tipo Vector2, che contiene come informazione una coppia di valori (x, y). La griglia, a livello
# logico, viene vista come una matrice 3x3.
#
# In base alla posizione generata dall'AI, viene mappata la posizione contenuta nel parametro, con
# la posizione della cella della griglia di gioco.
#
# @params relative_position: Vector2 --> Posizione logica della griglia di gioco.
func generate_ai_sprite(relative_position: Vector2) -> void:
	var sprite: Sprite = Sprite.new()

	sprite.texture = o_texture # Assegno la texture al nodo Sprite
	sprite.visible = true
	sprite.scale = SCALE_PLUS # Aumento le dimensioni dello sprite di un fattore 2.5 per l'asse x e y

	sprite.position = cells_positions[relative_position] + $Clickable.position
	sprite.name = cells_names[relative_position]

	sprite.add_to_group("o_texture_group")
	add_child(sprite)


# Funzione usata per il supporto al multiplayer.
#
# @params clicked_cell: Vector2 --> Posizione cella cliccata.
# @params clicked_cell_name: String --> Nome cella cliccata.
# @params turno: int --> Nuovo turno.
func _multiplayer_board(clicked_cell: Vector2, clicked_cell_name: String, turno: int) -> void:
	var key = game_node.callv("get_key", [cells_positions, clicked_cell])
	var online_sprite: String = online_board.call("get_sprite")

	if not game_node.callv("is_cell_full", [key]):
		if online_board.callv("generate_multiplayer_sprite", [online_sprite, clicked_cell, clicked_cell_name]):
			var vector_pos: Vector2 = game_node.callv("get_key", [cells_positions, clicked_cell])

			game_node.callv("update_multiplayer_board", [vector_pos, online_sprite]) # Aggiorno per il giocatore
			multiplayer_node.callv("send", [{"posizione": key, "enemy_sprite": online_sprite, "turno": turno}]) # Invio posizione al server
	else:
		online_board.turno -= 1


# Funzione richiamata quando il segnale "visibility_changed" viene innescato.
# Questo segnale viene attivato quando la visibilità del nodo cambia, quindi se passo
# dallo stato di 'visibile (true)' allo stato di 'invisibilie (false)', o viceversa.
func _on_Board_visibility_changed() -> void:
	if self.visible:
		if online_board.turno % 2 == ai_node_manager.PLAYER_VALUE:
			if online_board.player_sprite == online_board.SPRITE_DICT.O_S:
				$Rounds.text = "Tocca a te"
			elif online_board.player_sprite == online_board.SPRITE_DICT.X_S:
				$Rounds.text = "Tocca all'avversario"

		if get_parent().difficulty > 0:
			$Chat.visible = false
			$Rounds.visible = false

		else:
			$Chat.visible = true
			$Rounds.visible = true


# Funzioe chiamata quando viene premuto il bottone 'SendBrn'
func _on_SendBtn_pressed() -> void:
	if $Chat/TextMsg.text != "":
		$Chat/ChatText.push_color(Color("#ffffff")) # Definisco il colore del testo inviato all'interno del nodo ChatText
		$Chat/ChatText.add_text($Chat/TextMsg.text)
		$Chat/ChatText.newline()

		multiplayer_node.callv("send", [{"chat": $Chat/TextMsg.text}])
		$Chat/TextMsg.text = ""



func _create_click_audio(area_position: Vector2) -> void:
	var array_of_click: Array = get_tree().get_nodes_in_group("click_area")
	var click_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

	if array_of_click.size() > 0:
		for click in array_of_click:
			click.queue_free()



	click_audio.stream = load("res://assets/audio/Click_Area.wav")
	click_audio.volume_db = CLICK_AREA_AUDIO
	click_audio.position = area_position

	click_audio.add_to_group("click_area")
	get_parent().get_node("Board/Clickable").add_child(click_audio)

	click_audio.play(0)

extends Node

const SPRITE_DICT: Dictionary = {"O_S": "o_player", "X_S": "x_player"}
const SPRITE_GROUP: Dictionary = {"O_G": "o_texture_group", "X_G": "x_texture_group"}

var player_sprite: String = ''
var board: Node2D
var rounds_nodes: Label
var has_sprite: bool = false
var turno: int = 0


func _ready() -> void:
	board = get_tree().get_root().get_node("Game/Board")
	rounds_nodes = get_tree().get_root().get_node("Game/Board/Rounds")

# Funzione che imposta il tipo di sprite associato al giocatore.
#
# @params sprite: Dictionary --> Contiene le inforamzioni sullo sprite del giocatore
func set_sprite(sprite: Dictionary) -> void:
	player_sprite = sprite.get("spriteType")


# Funzione che restituisce il tipo di sprite associato al giocatore.
#
# @returns String --> Il tipo di sprite da usare.
func get_sprite() -> String:
	return player_sprite


# Funzione usata per creare lo sprite del giocatore e inserirlo nella casella di gioco premuta. La
# funzione restituisce 'true' in caso la sua creazione è avvenuta con successo, altrimenti restituirà 'false'.
#
# @params sprite_type: String --> Tipo di sprite da disegnare
# @params spot_position: Vector2 --> Posizione casella premuta
# @params spot_name: String --> Nome casella premuta
#
# @returns bool --> Esito creazione.
func generate_multiplayer_sprite(sprite_type: String, spot_position: Vector2, spot_name: String) -> bool:
	var o_texture_list: Array = get_tree().get_nodes_in_group(SPRITE_GROUP.O_G)
	var x_texture_list: Array = get_tree().get_nodes_in_group(SPRITE_GROUP.X_G)

	var sprite: Sprite = Sprite.new()
	var sprite_not_found: bool = true

	if sprite_type == SPRITE_DICT.O_S:
		if o_texture_list.size() > 0 or x_texture_list.size() > 0:
			if  _find_multiplayer_node_name(o_texture_list, spot_name):
				if  _find_multiplayer_node_name(x_texture_list, spot_name):
					sprite = _get_multiplayer_sprite(sprite, spot_position, spot_name, board.o_texture, SPRITE_GROUP.O_G)
					board.add_child(sprite)
				else:
					sprite_not_found = not sprite_not_found
			else:
				sprite_not_found = not sprite_not_found
		else:
			sprite = _get_multiplayer_sprite(sprite, spot_position, spot_name, board.o_texture, SPRITE_GROUP.O_G)
			board.add_child(sprite)


	elif sprite_type == SPRITE_DICT.X_S:
		if o_texture_list.size() > 0 or x_texture_list.size() > 0:
			if  _find_multiplayer_node_name(x_texture_list, spot_name):
				if  _find_multiplayer_node_name(o_texture_list, spot_name):
					sprite = _get_multiplayer_sprite(sprite, spot_position, spot_name, board.x_texture, SPRITE_GROUP.X_G)
					board.add_child(sprite)

				else:
					sprite_not_found = not sprite_not_found
			else:
				sprite_not_found = not sprite_not_found
		else:
			sprite = _get_multiplayer_sprite(sprite, spot_position, spot_name, board.x_texture, SPRITE_GROUP.X_G)
			board.add_child(sprite)

	return sprite_not_found


# Funzione usata per controllare l'esistenza di Sprite, inseriti nella
# griglia dall'utente, in una certa posizione. Restituisce 'false' se uno
# sprite possiede il nome indicato in spot_name, altrimenti 'true'.
#
# @params list_of_texture: Array --> Contiene tutti gli sprite dell'utente
# @params spot_name: String --> Nome dell'Area2D da ricercare
#
# @returns bool --> Esito della ricerca
func _find_multiplayer_node_name(list_of_texture: Array, spot_name: String) -> bool:
	var regex: RegEx = RegEx.new()

	for sprite in list_of_texture:
		if regex.compile(spot_name) == OK:
			if regex.search(sprite.name):
				return false
	return true


# Funzione usata per creare e restituire lo sprite associato al giocatore, fatto in base ai parametri 'texture' e 'group_name'.
#
# @params sprite: Sprite --> Istanza della classe Sprite.
# @params spot_position: Vector2 --> Posizione della cella premuta
# @params spot_name: String --> Nome della cella premuta
# @params texure: Texture --> Texture dello sprite
# @params group_name: String --> Nome gruppo di appartenenza dello sprite
#
# @returns Sprite --> Sprite del giocatore
func _get_multiplayer_sprite(sprite: Sprite, spot_position: Vector2, spot_name: String, texure: Texture, group_name: String) -> Sprite:
	var clickable_pos: Node2D = get_tree().get_root().get_node("Game/Board/Clickable")

	sprite.texture = texure
	sprite.scale = board.SCALE_PLUS
	sprite.position = spot_position + clickable_pos.position

	sprite.name = spot_name
	sprite.add_to_group(group_name)
	sprite.visible = true

	return sprite


# Funzione usata per disegnare lo sprite avversario. Le informazioni necessarie alla sua creazione
# sono contenute all'interno del parametro 'payload'. La funzione restituisce un Array che contiene
# la posizione dello sprite avversario, convertita da una stringa, e le informazioni sul tipo di sprite assegnato.
# Nella posizione 0 si trova la posizione, nella posizione 1 il tipo di sprite che usa.
#
# @params payload: Dictionary --> Dizionario contenente le inforazioni sullo sprite avversario
#
# @retuns Array --> Posizione e tipo di sprite dell'avversario.
func draw_enemy_sprite(payload: Dictionary) -> Array:
	var sprite: Sprite = Sprite.new()
	var relative_position: Vector2 = _str_to_vector2(payload["enemyInfo"]["posizione"])

	var absolute_position: Vector2 = board.cells_positions[relative_position]
	var cell_name: String = board.cells_names[relative_position]

	var sprite_type: String = payload["enemyInfo"]["enemy_sprite"]
	turno = int(payload["enemyInfo"]["turno"])

	if sprite_type == SPRITE_DICT.O_S:
		sprite = _get_multiplayer_sprite(sprite, absolute_position, cell_name, board.o_texture, SPRITE_GROUP.O_G)
		board.add_child(sprite)

	elif sprite_type == SPRITE_DICT.X_S:
		sprite = _get_multiplayer_sprite(sprite, absolute_position, cell_name, board.x_texture, SPRITE_GROUP.X_G)
		board.add_child(sprite)

	return [relative_position, sprite_type]




# Funzione usata per convertire una stringa, che rappresenta il Vector2 inviato
# dal server, in un Vector2.
#
#	Esempio:
#		str_v = '(1, 1)' -> I valori che cerchiamo sono quelli numerici e si
# 							trovano rispettivamente nella posizione 1 e 4 della
#							stringa.
#		returns Vector2(1, 1)
#
# @params str_v: String --> Stringa che rappresenta il Vector2
#
# @returns Vecto2 --> Vector2 ricavato dalla stringa
func _str_to_vector2(str_v: String) -> Vector2:
	var x_coord: int = int(str_v[1])
	var y_coord: int = int(str_v[4])

	return Vector2(x_coord, y_coord)

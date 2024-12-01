extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/Slums/SpawnRoom1.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Slums/Room1.tscn"), preload("res://Rooms/Slums/Room2.tscn"), preload("res://Rooms/Slums/Room3.tscn"), preload("res://Rooms/Slums/Room4.tscn"), preload("res://Rooms/Slums/Room5.tscn")]
const END_ROOMS: Array = [preload("res://Rooms/Slums/EndRoom1.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_COORDS: Vector2i = Vector2i(10, 10)
const RIGHT_WALL_TILE_COORDS: Vector2i = Vector2i(7, 13)
const LEFT_WALL_TILE_COORDS: Vector2i = Vector2i(8, 14)

@export var num_levels: int = 8

@onready var player: CharacterBody2D = get_parent().get_node("Player")


func _ready() -> void:
	SavedData.current_floor += 1	
	if SavedData.current_floor == 3:
		num_levels = 3
	_spawn_rooms()


func _spawn_rooms() -> void:
	var previous_room: Node2D

	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPosition").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()

			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2

			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y), 1, LEFT_WALL_TILE_COORDS)
				previous_room_tilemap.set_cell(1, exit_tile_pos + Vector2i(-1, -y), 1, FLOOR_TILE_COORDS)
				previous_room_tilemap.set_cell(1, exit_tile_pos + Vector2i(0, -y), 1, FLOOR_TILE_COORDS)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y), 1, RIGHT_WALL_TILE_COORDS)

			var room_tilemap: TileMap = room.get_node("TileMap")
			var door_coords = previous_room.global_position + previous_room_door.global_position
			var entrance_y_offset = Vector2.UP * room_tilemap.local_to_map(room.get_node("Entrance/Position2D").position).y * TILE_SIZE + Vector2(0, -(16))
			var corridor_y_offset = Vector2.UP * (1 + corridor_height) * TILE_SIZE
			var entrance_x_offset = Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Position2D").position).x * TILE_SIZE

			room.position = door_coords + entrance_y_offset + corridor_y_offset + entrance_x_offset

		add_child(room)
		previous_room = room


func _spin_room(clockwise: bool, room: Room) -> void:
	var entrance: Marker2D = room.get_node("Entrance/Position")
	var exits: Array[Marker2D] = room.get_node("Exits").get_children()

	if clockwise:
		for exit in exits:
			match exit.name:
				"Top":
					exit.name = "Right"
				"Right":
					exit.name = "Bottom"
				"Bottom":
					exit.name = "Left"
				"Left":
					exit.name = "Top"
				_:
					
	else:






var occupied_positions: Dictionary = {}

func _spawn_rooms() -> void:
	occupied_positions.clear()
	var start_room = _create_room(SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()], Vector2(0, 0))
	player.position = start_room.get_node("PlayerSpawnPosition").position
	var open_positions = [start_room.get_node("Exits/Top").position]
	
	for i in range(1, num_levels):
		if open_positions.is_empty():
			break  # Нет доступных мест для размещения новых комнат
		var current_pos = open_positions.pop_back()
		var room_scene = END_ROOMS[randi() % END_ROOMS.size()] if i == num_levels - 1 else INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()]
		var new_room = _create_room(room_scene, current_pos)
		
		if i != num_levels - 1:
			var exits = new_room.get_node("Exits").get_children()
			for exit in exits:
				var exit_pos = new_room.global_position + exit.global_position
				var grid_pos = exit_pos / TILE_SIZE
				if grid_pos in occupied_positions:
					continue
				occupied_positions[grid_pos] = true
				open_positions.append(grid_pos)

func _create_room(scene: PackedScene, position: Vector2) -> Node2D:
	var room = scene.instantiate()
	room.position = position * TILE_SIZE
	add_child(room)
	occupied_positions[position] = true
	return room

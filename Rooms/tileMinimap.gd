extends Control


@export var camera_node: NodePath
@export var tilemap_nodes: Array[NodePath]
@export var cell_colors: Dictionary
@export var zoom = 1.0


@onready var camera  = get_node(camera_node)
var tilemaps = []


func _ready():
	for node in tilemap_nodes:
		tilemaps.append(get_node(node))


func get_cells(tilemap : TileMap, id):
	return tilemap.get_used_cells_by_id(id)


func _draw():
	draw_set_transform(size / 2, 0, Vector2.ONE)

	for tilemap in tilemaps:
		var camera_position = camera.get_screen_center_position()
		var camera_cell = tilemap.local_to_map(camera_position)
		var tilemap_offset = Vector2(camera_cell) + (camera_position - tilemap.map_to_local(camera_cell)) / 16

		for id in cell_colors.keys():
			var color = cell_colors[id]
			var cells = get_cells(tilemap, id)
			for cell in cells:
				draw_rect(Rect2((Vector2(cell) - tilemap_offset) * zoom, Vector2.ONE * zoom), color)


func _process(_delta):
	queue_redraw()

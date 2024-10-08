extends TileMap

@export var map_w = 150
@export var map_h = 100
@export var min_room_size = 20
@export var min_room_factor = 0.4
@onready var Util = $"../Util"

enum Tiles {Dirt, Wood, Roof, Wall}

var tree = {}
var leaves = []
var leaf_id = 0
var rooms = []

func generate():
	clear()
	fill_roof()
	start_tree()
	create_leaf(0)
	create_rooms()
	join_rooms()
	clear_deadends()


func fill_roof():
	for x in range(0, map_w):
		for y in range(0, map_h):
			set_cell(0, Vector2i(x,y), Tiles.Wood, Vector2i(1,1))
			
func start_tree():
	rooms = []
	tree = {}
	leaves = []
	leaf_id = 0

	tree[leaf_id] = { "x": 1, "y": 1, "w": map_w-2, "h": map_h-2 }
	leaf_id += 1

func create_leaf(parent_id):
	var x = tree[parent_id].x
	var y = tree[parent_id].y
	var w = tree[parent_id].w
	var h = tree[parent_id].h

	# used to connect the leaves later
	tree[parent_id].center = { x = floor(x + w/2), y = floor(y + h/2) }

	# whether the tree has space for a split
	var can_split = false

	# randomly split horizontal or vertical
	# if not enough width, split horizontal
	# if not enough height, split vertical
	var split_type = Util.choose(["h", "v"])
	if   (min_room_factor * w < min_room_size):  
		split_type = "h"
	elif (min_room_factor * h < min_room_size):  
		split_type = "v"

	var leaf1 = {}
	var leaf2 = {}

	# try and split the current leaf,
	# if the room will fit
	if (split_type == "v"):
		var room_size = min_room_factor * w
		if (room_size >= min_room_size):
			var w1 = Util.randi_range(room_size, (w - room_size))
			var w2 = w - w1
			leaf1 = { x = x, y = y, w = w1, h = h, split = 'v' }
			leaf2 = { x = x+w1, y = y, w = w2, h = h, split = 'v' }
			can_split = true
	else:
		var room_size = min_room_factor * h
		if (room_size >= min_room_size):
			var h1 = Util.randi_range(room_size, (h - room_size))
			var h2 = h - h1
			leaf1 = { x = x, y = y, w = w, h = h1, split = 'h' }
			leaf2 = { x = x, y = y+h1, w = w, h = h2, split = 'h' }
			can_split = true

	# rooms fit, lets split
	if (can_split):
		leaf1.parent_id    = parent_id
		tree[leaf_id]      = leaf1
		tree[parent_id].l  = leaf_id
		leaf_id += 1

		leaf2.parent_id    = parent_id
		tree[leaf_id]      = leaf2
		tree[parent_id].r  = leaf_id
		leaf_id += 1

		# append these leaves as branches from the parent
		leaves.append([tree[parent_id].l, tree[parent_id].r])

		# try and create more leaves
		create_leaf(tree[parent_id].l)
		create_leaf(tree[parent_id].r)
		
func create_rooms():
	for leaf_id in tree:
		var leaf = tree[leaf_id]
		if leaf.has("l"): continue # if node has children, don't build rooms

		if Util.chance(75):
			var room = {}
			room.id = leaf_id;
			room.w  = Util.randi_range(min_room_size, leaf.w) - 1
			room.h  = Util.randi_range(min_room_size, leaf.h) - 1
			room.x  = leaf.x + floor((leaf.w-room.w)/2) + 1
			room.y  = leaf.y + floor((leaf.h-room.h)/2) + 1
			room.split = leaf.split

			room.center = Vector2()
			room.center.x = floor(room.x + room.w/2)
			room.center.y = floor(room.y + room.h/2)
			rooms.append(room);

	# draw the rooms on the tilemap
	for i in range(rooms.size()):
		var r = rooms[i]
		for x in range(r.x, r.x + r.w):
			for y in range(r.y, r.y + r.h):
				if(x == r.x): 
					set_cell(0, Vector2i(x,y), Tiles.Roof, Vector2i(randi_range(0,2),0))
				elif(x == r.x + r.w - 1): 
					set_cell(0, Vector2i(x,y), Tiles.Roof, Vector2i(randi_range(0,2),0))
				elif(y == r.y):
					set_cell(0, Vector2i(x,y), Tiles.Roof, Vector2i(randi_range(0,2),0))
				elif (y == r.y + r.h - 1):
					set_cell(0, Vector2i(x,y), Tiles.Roof, Vector2i(randi_range(0,2),0))					
				else: 
					set_cell(0, Vector2i(x,y), Tiles.Dirt, Vector2i(1,1))
				print(str(" "))

func join_rooms():
	for sister in leaves:
		var a = sister[0]
		var b = sister[1]
		connect_leaves(tree[a], tree[b])

func connect_leaves(leaf1, leaf2):
	var x = min(leaf1.center.x, leaf2.center.x)
	var y = min(leaf1.center.y, leaf2.center.y)
	var w = 1
	var h = 1

	# Vertical corridor
	if (leaf1.split == 'h'):
		x -= floor(w/2)+1
		h = abs(leaf1.center.y - leaf2.center.y)
	else:
		# Horizontal corridor
		y -= floor(h/2)+1
		w = abs(leaf1.center.x - leaf2.center.x)

	# Ensure within map
	x = 0 if (x < 0) else x
	y = 0 if (y < 0) else y

	for i in range(x, x+w):
		for j in range(y, y+h):
			if(get_cell_source_id(0, Vector2i(i,j)) == Tiles.Wood ||
			 get_cell_source_id(0, Vector2i(i,j)) == Tiles.Roof): set_cell(0, Vector2i(i,j), Tiles.Dirt, Vector2i(1,1))
	
func clear_deadends():
	var done = false

	while !done:
		done = true

		for cell in get_used_cells(0):
			if get_cell_source_id(0, cell) != Tiles.Dirt: continue

			var roof_count = check_nearby(cell.x, cell.y)
			if roof_count == 3:
				set_cell(0, cell, Tiles.Wood, Vector2i(1,1))
				done = false

# check in 4 dirs to see how many tiles are roofs
func check_nearby(x, y):
	var count = 0
	if get_cell_source_id(0, Vector2i(x+1,y))   == Tiles.Wood:  count += 1
	if get_cell_source_id(0, Vector2i(x-1,y))   == Tiles.Wood:  count += 1
	if get_cell_source_id(0, Vector2i(x,y+1))   == Tiles.Wood:  count += 1
	if get_cell_source_id(0, Vector2i(x,y-1))   == Tiles.Wood:  count += 1
	print(" ")
	return count
# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	generate()# Replace with function body.

extends Node2D

onready var tileRoads = get_node("../tileRoads")
onready var debugUI = get_node("../debugUI")

var astar = AStar2D.new()

var nodes = {} #contains the vector location of a cell matched with its id

var spotCheckList = { 
					1:[Vector2(1, 0)], #up to down right
					0:[Vector2(0,1)], #left to up
					2:[Vector2(1,0)], # down
					3:[Vector2(0,-1)], # right straight
					4:[Vector2(0,1)], #right to down
					5:[Vector2(0,-1)], #left to up
					6:[Vector2(-1,0)], #up
					7:[Vector2(0, 1 )], #left 
					8:[Vector2(0,-1)], #down to right
					9:[Vector2(-1,0)], #right to up
					10:[Vector2(1,0)], #right to down
					11:[Vector2(0,-1)], #up to right
					12:[Vector2(0,1), Vector2(0,-1), Vector2(1,0)], #3 way up right down
					13:[Vector2(0,1), Vector2(0,-1), Vector2(-1,0)],
					15:[Vector2(1,0), Vector2(0,-1), Vector2(-1,0)], 
					16:[Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)],
					17:[Vector2(1,0), Vector2(-1,0), Vector2(0,1)],
					}

# later, we can make an "acceptor" list, which would disallow access
# from specific directions 
# i.e: down to left turn wouldn't accept right nodes, etc.


func _ready():
	initNodes()
	populateGraph()


func initNodes():
	#assign every existing cell a unique id
	var currentIndx = 0
	for i in tileRoads.get_used_cells():
		nodes[i] = currentIndx
		
		astar.add_point(currentIndx, Vector2(0,0), 0) #default position til updated
		currentIndx += 1


func populateGraph():
	var used = tileRoads.get_used_cells()
	print(used)
	for pos in used: #iterate through positions of tiles
		
		var currentCellID = nodes[pos]
		print("Current cell id: %s" % currentCellID)
		
		print("Current position: %s" % pos)
		
		#current cell type
		var type = (tileRoads.get_cellv(pos))
		print("Current type: %s" % type)
		
		# check connections #
		var spotChecks = spotCheckList[type] #retrieves appropiate spotChecks for current type
		var connections = [] #array of vectors of the locations of found cells
		
		debugUI.textToDraw[type] = tileRoads.map_to_world(pos)
		
		for i in range(0, len(spotChecks)):
			#iterate through spots to add connecting cells in
			#offset parent cells position by 1 in given axis to check given adjacent cells
			var cellFound = Vector2(pos.x+ spotChecks[i].x, pos.y + spotChecks[i].y)  #vector2 of adjacent cell
			
			#debugUI.spots.append( (tileRoads.map_to_world(cellFound)) + Vector2(32,32) )
			
			
			if (tileRoads.get_cellv(cellFound) != -1): #check if cell exists
				var cellFoundID = nodes[cellFound]
				#for debug
				var positionInWorld = (tileRoads.map_to_world(cellFound) + Vector2(32,32))			
				debugUI.spots.append(positionInWorld)
				#debugUI.textToDraw[cellFoundID] = positionInWorld
				
				connections.append(cellFound) #adds location of found cell to connections
		
		connectNode(currentCellID, pos, connections, 0)
	
#	print("\n\nconnections of zero ")
#	print(astar.get_points())
#	print(astar.get_point_connections(0))
#	print(astar.get_point_path(0, 5))
		

func connectNode(id, pos : Vector2, connections, scaleFactor):
	#check if point exists probably..
	astar.set_point_position(id, pos)
	for i in connections:
		astar.connect_points(id, nodes[i], false)


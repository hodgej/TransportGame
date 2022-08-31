extends KinematicBody2D

onready var nav = get_node("../nav")

var path = []
var posPath = []

var go = true

func _process(delta):
	if go:
		if posPath.size() > 0:
			global_position = posPath[0]
			posPath.remove(0)
			go = false
			$Timer.start()



func move_to(from, to):
	path = []
	posPath = []
	
	path = nav.astar.get_point_path(from, to)
	
	for i in path:
		posPath.append(nav.tileRoads.map_to_world(i) + Vector2(32,32))


func _on_Timer_timeout():
	go = true

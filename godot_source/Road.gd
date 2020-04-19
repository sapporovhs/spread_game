extends Node2D

onready var Game = get_tree().get_root().get_node("Game")

var connected_cities = [0,0]
var is_closed = false

func _ready():
	reset()
	
func reset():
	open()
	show()

func ClickRect_init(city_index):
	var center = $Line.points[0]
	var relative_center = $Line.points[1]-$Line.points[0]
	var CR_rotation = atan(relative_center.y/relative_center.x)
	if relative_center.y < 0:
		CR_rotation -=PI/2.0
		if relative_center.x < 0:
			CR_rotation +=PI
	else:
		CR_rotation +=PI/2.0
		if relative_center.x > 0:
			CR_rotation +=PI
	var length = sqrt((relative_center.x*relative_center.x)+(relative_center.y*relative_center.y))
	$ClickRect.rect_position = center- Vector2(5.0,0)
	$ClickRect.rect_rotation = CR_rotation/PI*180.0
	$ClickRect.rect_size.y = length

func open():
	is_closed = false
	$Line.default_color = Globals.colors[0]
	Game.update_connection_graph()

func close():
	is_closed = true
	$Line.default_color = Globals.colors[1]
	Game.update_connection_graph()

func toggle_road_close():
	is_closed = !is_closed
	if is_closed:
		AudioNode.play_sfx(3)
		$Line.default_color = Globals.colors[1]
	else:
		AudioNode.play_sfx(2)
		$Line.default_color = Globals.colors[0]
	Game.update_connection_graph()

func _on_ClickRect_gui_input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		toggle_road_close()

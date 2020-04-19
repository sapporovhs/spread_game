extends Node2D

const SECONDS_PER_DAY = 2.0

onready var Game = get_tree().get_root().get_node("Game")

var hand_tip_position = Vector2()

func _ready():
	$Hand.points[0] = $Face.rect_size/2.0
	update_day_label()


func _process(delta):
	if !Game.paused:
		Globals.minute += delta
		if Globals.minute > SECONDS_PER_DAY:
			Globals.day += 1
			update_day_label()
			Game.get_node("UI").update_plot()
			Globals.minute -= SECONDS_PER_DAY
			if Globals.day == 30:
				Game.finish()
		set_hand(Globals.minute)
	
func set_hand(tick):
	var new_hand_position = Vector2(sin(tick/SECONDS_PER_DAY*2.0*PI)*$Face.rect_size.x/3.0+$Face.rect_size.x/2.0,-cos(tick/SECONDS_PER_DAY*2.0*PI)*$Face.rect_size.y/3.0+$Face.rect_size.y/2.0)
	$Hand.points[1] = new_hand_position

func update_day_label():
	$DayLabel.text = "Day "+str(Globals.day)

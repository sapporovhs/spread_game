extends Control

onready var Game = get_tree().get_root().get_node("Game")

func _ready():
	reset()

func reset():
	$GameMenu/RankLabel.hide()
	$GameMenu.hide()
	$GameMenu/EconomyPlot/Line.clear_points()
	$GameMenu/VirusPlot/Line.clear_points()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SingleCityStatsLabel_gui_input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		Game.hide_city_stats()

func update_plot():
	$GameMenu/EconomyPlot/Line.add_point(Vector2(-1,1)*(Vector2(0.0,$GameMenu/EconomyPlot.rect_size.y)-Vector2(Globals.day,Globals.track_economy)/Vector2(30.0,100.0)*$GameMenu/EconomyPlot.rect_size))
	$GameMenu/VirusPlot/Line.add_point(Vector2(-1,1)*(Vector2(0.0,$GameMenu/VirusPlot.rect_size.y)-Vector2(Globals.day,Globals.track_virus)/Vector2(30.0,100.0)*$GameMenu/VirusPlot.rect_size))


func _on_MenuButton_pressed():
	$GameMenu.visible = !$GameMenu.visible

func _on_StartButton_pressed():
	$MainMenu.hide()
	reset()
	Game.paused = false
	Game.reset()

func _on_QuitButton_pressed():
	Game.paused = true
	$MainMenu.show()
	AudioNode.play_music(0)

func _on_HowToPlayButton_pressed():
	$HowToPlay.show()

func _on_RichTextLabel_gui_input(event):
	if event.is_pressed() and event.button_index == BUTTON_LEFT:
		$HowToPlay.hide()

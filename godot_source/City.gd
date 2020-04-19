extends Node2D

onready var Game = get_tree().get_root().get_node("Game")

var city_name = null
var industry = 0
var economy_level = 100
var virus_level = 0

var days_testing = 0
var days_quarantined = 0

var economy_rate = -0.5
var virus_rate = 0.0

var has_medical = true
var has_telecom = true
var has_oil = true

var quarantined = false
var testing = false
var destroyed = false

func _ready():
	update_status_UI()

func reset():
	city_name = null
	industry = 0
	economy_level = 100
	virus_level = 0
	
	days_testing = 0
	days_quarantined = 0
	
	economy_rate = -0.5
	virus_rate = 0.0
	
	has_medical = true
	has_telecom = true
	has_oil = true
	
	quarantined = false
	testing = false
	destroyed = false
	$TestingIcon.hide()
	$QuarantinedIcon.hide()
	show()

func _process(delta):
	if !destroyed and (economy_level == 0 or virus_level == 100):
		destroyed = true
		AudioNode.play_sfx(4)
		economy_level = 0
		virus_level = 0
		economy_rate = 0.0
		virus_rate = 0.0
		hide()
		Game.remaining_cities -= 1
		if Game.remaining_cities == 0:
			Game.finish()
		for road in Game.get_node("Roads").get_children():
			if get_index() in road.connected_cities:
				road.hide()
				for i in range(3):
					Game.connection_graph[get_index()][(get_index()+i)%3] = false
					Game.connection_graph[(get_index()+i)%3][get_index()] = false

func update_status_UI():
	$EconomyBar.rect_scale.x = economy_level/100.0
	$VirusBar.rect_scale.x = virus_level/100.0
	if has_telecom:
		if economy_rate < 0:
			$EconomyRateLabel.text = "-"
		else:
			$EconomyRateLabel.text = "+"
		if virus_rate < 0:
			$VirusRateLabel.text = "-"
		else:
			$VirusRateLabel.text = "+"
	else:
		$EconomyRateLabel.text = "?"
		$VirusRateLabel.text = "?"
	if has_telecom:
		$EconomyBar.show()
		$VirusBar.show()
	else:
		$EconomyBar.hide()
		$VirusBar.hide()

func update_states(connection_subgraph):
	for city in Game.get_node("Cities").get_children():
		var resource = city.industry
		var has_resource = connection_subgraph[city.get_index()]
		if resource == Globals.INDUSTRIES.MEDICAL:
			has_medical = has_resource
		elif resource == Globals.INDUSTRIES.TELECOM:
			has_telecom = has_resource
		else:
			has_oil = has_resource

func change_economy():
	if !destroyed:
		economy_level = clamp(economy_level+economy_rate,0.0,100.0)
	else:
		economy_level = 0.0
	
func change_virus():
	if !destroyed:
		virus_level = clamp(virus_level+virus_rate,0.0,100.0)
	else:
		virus_level = 0.0

func nudge_rates():
	economy_rate *= 0.9+randf()*0.2
	virus_rate *= 0.9+randf()*0.2

func _on_Sprite_gui_input(event):
	if(event.is_pressed() and event.button_index == BUTTON_LEFT):
#		if (event.doubleclick):
		if !quarantined and !testing:
			quarantined = true
			AudioNode.play_sfx(0)
			$QuarantinedIcon.show()
		elif quarantined and has_medical:
			quarantined = false
			$QuarantinedIcon.hide()
			testing = true
			AudioNode.play_sfx(1)
			$TestingIcon.show()
		else:
			quarantined = false
			testing = false
			$QuarantinedIcon.hide()
			$TestingIcon.hide()
		Game.show_city_stats(get_index())

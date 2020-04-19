extends Node2D

var connection_graph = [[true,true,true],[true,true,true],[true,true,true]]
var showing_city_index = 0
var medical_city_index = 0
var remaining_cities = 3
var paused = true

var city_origins = [Vector2(100,150),Vector2(225,300),Vector2(90,360)]

func _ready():
	AudioNode.play_music(0)

func reset():
	AudioNode.play_music(1)
	var industry_indices = [0,1,2]
	Globals.reset()
	showing_city_index = 0
	remaining_cities = 3
	randomize()
	industry_indices.shuffle()
	var city_index = 0
	for city in $Cities.get_children():
		city.reset()
		city.position = city_origins[city_index]+Vector2(randf()*50,randf()*100)
		city.industry = industry_indices[city_index]
		if city.industry == Globals.INDUSTRIES.MEDICAL:
			medical_city_index = city.get_index()
		city.city_name = Globals.get_random_city_name()
		city.get_node("NameTag").text = city.city_name
		city.get_node("Sprite").texture = load("res://assets/city"+str(randi()%3+1)+".png")
		city.get_node("IndustryIcon").texture = load(Globals.industry_icons[city.industry])
		city_index += 1
	city_index = 0
	for road in $Roads.get_children():
		road.reset()
		road.position = Vector2(0.0,0.0)
		road.connected_cities = [city_index,(city_index+1)%3]
		var city_1_center = $Cities.get_child(road.connected_cities[0]).get_global_transform().get_origin()+Vector2(25.0,50.0)
		var city_2_center = $Cities.get_child(road.connected_cities[1]).get_global_transform().get_origin()+Vector2(25.0,50.0)
		road.get_child(0).points[0] = city_1_center
		road.get_child(0).points[1] = city_2_center
		road.ClickRect_init(city_index)
		city_index += 1
	update_accum_stats()

func _process(delta):
	pass

func update_city_stats():
	var city = $Cities.get_child(showing_city_index)
	if city.has_telecom:
		$UI/SingleCityStatsLabel.text = city.city_name + "\n$ " + str(city.economy_level) + "\n* " + str(city.virus_level)
	else:
		$UI/SingleCityStatsLabel.text = city.city_name + "\n$ " + "???" + "\n* " + "???"

func show_city_stats(city_index):
	showing_city_index = city_index
	update_city_stats()
	$UI/SingleCityStatsLabel.show()

func hide_city_stats():
	$UI/SingleCityStatsLabel.hide()	

func toggle_city_stats(city_index):
	if $UI/SingleCityStatsLabel.visible and city_index==showing_city_index:
		$UI/SingleCityStatsLabel.hide()
	else:
		showing_city_index = city_index
		update_city_stats()
		$UI/SingleCityStatsLabel.show()

func update_accum_stats():
	var economy_percent = 0
	var virus_percent = 0
	for city in $Cities.get_children():
		economy_percent += city.economy_level
		virus_percent += city.virus_level
	Globals.track_economy = int(economy_percent/remaining_cities)
	Globals.track_virus = int(virus_percent/remaining_cities)
	$UI/AccumStatsLabel.text = "World\n$ " + str(Globals.track_economy) + "\n* " + str(Globals.track_virus)

func update_connection_graph():
	for road in $Roads.get_children():
		connection_graph[road.connected_cities[0]][road.connected_cities[1]] = !road.is_closed
		connection_graph[road.connected_cities[1]][road.connected_cities[0]] = !road.is_closed

func lapse():
	for city in $Cities.get_children():
		city.update_states(connection_graph[city.get_index()])
		city.nudge_rates()
#		if city.has_medical:
#			city.testing_level += 1
		if !city.has_telecom and city.quarantined:
			city.economy_rate -= 0.5
		if city.has_oil:
			city.economy_rate += abs(city.economy_rate*0.5)
		else:
			city.economy_rate -= abs(city.economy_rate*0.5)
		if city.testing:
			city.days_testing += 1
			city.virus_rate = city.days_testing*-0.1
			var testing_continues = connection_graph[city.get_index()][medical_city_index]# and !$Cities.get_child(medical_city_index).quarantined
			if medical_city_index != city.get_index():
				city.economy_rate -= 1.2
				if !testing_continues:
					city.testing = false
					city.get_node("TestingIcon").hide()
					
		else:
			city.days_testing = 0
		if city.quarantined:
			city.days_quarantined +=1
			city.economy_rate -= 0.5*city.days_quarantined
		else:
			city.days_quarantined = 0
			city.change_virus()
		for city_connected in connection_graph[city.get_index()]:
			if city_connected:
				if !city.quarantined:
					city.virus_rate += 0.33
		city.economy_rate -= city.virus_rate/100.0
		city.change_economy()
		city.update_status_UI()
	update_accum_stats()
	update_city_stats()
	$UI.update_plot()

func _on_Timer_timeout():
	if !paused:
		if remaining_cities == 0:
			finish()
		lapse()

func finish():
	AudioNode.stop_music()
	var rank = ""
	if remaining_cities == 0:
		rank = "D"
	if Globals.day == 30:
		if Globals.track_economy > 50 and Globals.track_virus < 50:
			if remaining_cities == 1:
				rank = "S"
			elif remaining_cities == 2:
				rank = "SS"
			else:
				rank = "SSS"
		else:
			if remaining_cities == 1:
				rank = "C"
			elif remaining_cities == 2:
				rank = "B"
			else:
				rank = "A"
	paused = true
	$UI/GameMenu/RankLabel.text = "Game Over\nDay: "+str(Globals.day)+"\nRank: "+rank
	$UI/GameMenu.show()
	$UI/GameMenu/RankLabel.show()
				

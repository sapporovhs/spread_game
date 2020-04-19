extends Node

var city_prefixes = ["Grove","Sun","Old","Bridge"]
var city_suffixes = ["ville","port","shire","berg"]
var city_names = []

var industry_icons = ["res://assets/medical.png","res://assets/telecom.png","res://assets/oil.png"]
enum INDUSTRIES {MEDICAL,TELECOM,OIL}
var colors = []

var track_economy = 100
var track_virus = 0

var minute = 0.0
var day = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	colors.append("ff814c00") # 0 brown
	colors.append("2f641000") # 1 dar-red

func reset():
	city_names = []
	track_economy = 100
	track_virus = 0
	minute = 0.0
	day = 0

func get_random_city_name():
	var city_name = city_prefixes[randi()%len(city_prefixes)]+city_suffixes[randi()%len(city_suffixes)]
	while city_name in city_names:
		city_name = city_prefixes[randi()%len(city_prefixes)]+city_suffixes[randi()%len(city_suffixes)]
	city_names.append(city_name)
	return city_name

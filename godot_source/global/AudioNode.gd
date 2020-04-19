extends Control

onready var bgm = [preload("res://assets/title.ogg"),preload("res://assets/game.ogg")]
var sfx = [preload("res://assets/lockdown.wav"), preload("res://assets/testing.wav"),preload("res://assets/road_open.wav"),preload("res://assets/road_closed.wav"),preload("res://assets/city_destoyed.wav")]

func _ready():
	pass

func play_sfx(n):
	$SFX.stream = sfx[n]
	$SFX.play()

func play_music(n):
	$Music.stream = bgm[n]
	$Music.play()

func stop_music():
	$Music.stop()

func _on_Music_finished():
	pass

extends Node2D

func _ready():
	$Background.texture.noise.seed = randi()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Node2D

@export var speed = 20
@export var innit_rotation = 90
var mouse_position = null
var sinTimer = 0
@onready var Body = $Body
@onready var Tentacles = $Tentacles

func _ready():
	for Tentacle in Tentacles.get_children():
		var firstPoint = Tentacle.VerletHandler.PointContainer.get_children()[0]
		Tentacle.offset = Body.global_position - Tentacle.global_position
		
func _physics_process(delta):
	
	sinTimer += delta * 6.5
	
	var bodydirection = (get_global_mouse_position() - Body.global_position).normalized()
	var bodyvelocity = bodydirection * speed/100 * ((0.5 * sin(sinTimer) + 0.75))
	
	Body.global_position += bodyvelocity
	Body.rotation += (Body.get_local_mouse_position().angle() + deg_to_rad(innit_rotation)) * 0.05
	
	for Tentacle in Tentacles.get_children():
		var firstPoint = Tentacle.VerletHandler.PointContainer.get_children()[0]
		
		firstPoint.global_position = Body.to_global(Body.to_local(Body.global_position - Tentacle.offset).rotated(Body.rotation))
		#firstPoint.global_position = (Body.global_position - Tentacle.offset)

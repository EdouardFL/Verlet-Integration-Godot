extends Node2D

@onready var VerletHandler = $VerletHandler
@export var Point_Amount: int = 5
@export var Stick_Length: float = 10.0
@export var TentacleColor: Color = Color.HOT_PINK
var offset = Vector2(0,0)

func _ready():
	
	VerletHandler.DrawColor = TentacleColor
	
	var current_pos = global_position
	var previous_point
	for i in Point_Amount:
		var point = VerletHandler.add_point(current_pos)
		current_pos.y += Stick_Length
		
		#if i == 0:
		#	point.locked = true
			
		if previous_point:
			VerletHandler.add_stick(previous_point, point, Stick_Length)
		previous_point = point

func _physics_process(delta):
	VerletHandler.queue_redraw()
	
	#VerletHandler.PointContainer.get_children()[0].global_position = get_global_mouse_position()
	

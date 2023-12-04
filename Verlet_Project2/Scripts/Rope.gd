extends Node2D

@export var SegmentAmount: int = 5
@export var StickSize: float = 5
@onready var VerletHandler = $VerletHandler

func _ready():
	generate_grid()
	generate_sticks()
	
func _process(delta):
	var FirstP = VerletHandler.PointContainer.get_children()[0]
	FirstP.position = get_global_mouse_position()
	
func generate_grid():
	var currentPos = global_position
	
	for i in SegmentAmount:
		var p = VerletHandler.add_point(currentPos)
		if i == 0:
			p.locked = true
		currentPos += Vector2(StickSize, 0)
		
func generate_sticks():
	for i in SegmentAmount:
		if i > 0:
			var current_p = VerletHandler.PointContainer.get_children()[i]
			var previous_p = VerletHandler.PointContainer.get_children()[i-1]
			if previous_p:
				VerletHandler.add_stick(current_p, previous_p, StickSize)

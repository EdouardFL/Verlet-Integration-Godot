extends Node2D

@export var Rows: int
@export var Collums: int
@export var StickSize: float
@onready var VerletHandler = $VerletHandler

func _ready():
	generate_grid()
	generate_sticks()
	
func generate_grid():
	var currentPos = global_position
	
	for c in Collums:
		for r in Rows:	
			VerletHandler.add_point(currentPos)
			currentPos += Vector2(StickSize, 0)
			
		currentPos = Vector2(global_position.x, currentPos.y + StickSize)
		
func generate_sticks():
	var currentPos = global_position
	var alternate = true
	
	for c in Collums:
		for r in Rows:
			print(currentPos)
			var nearest_point = VerletHandler.get_nearest_point(currentPos)
			
			if c == 0:
				if alternate == true:
					nearest_point.locked = true
					alternate = false
				elif alternate == false:
					alternate = true
			
			var chosen_points = [VerletHandler.get_nearest_point(currentPos + Vector2(StickSize,0)), VerletHandler.get_nearest_point(currentPos + Vector2(0,StickSize))]
			for p in chosen_points:
				if p:
					VerletHandler.add_stick(nearest_point, p, StickSize)
				
			currentPos += Vector2(StickSize, 0)
			
		currentPos = Vector2(global_position.x, currentPos.y + StickSize)
		
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var MousePos = get_global_mouse_position()
		var ClosestStick = VerletHandler.get_nearest_stick(MousePos)
		if ((ClosestStick.pointA.global_position + ClosestStick.pointB.global_position)/2).distance_to(MousePos) < 10:
			ClosestStick.queue_free()
		
		

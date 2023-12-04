extends Node2D

@export var ShowDebug: bool
@export var Gravity: float = 1
@export var Iterations: int = 1
@export var DrawColor: Color = Color.WHITE
@export var DampFactor: float = 1
@onready var PointContainer = $PointContainer
@onready var StickContainer = $StickContainer

func _process(delta):
	for p in PointContainer.get_children():
		if !p.locked:
			var PositionBeforeUpdate = p.global_position
			p.global_position += (p.global_position - p.previous_position) * (DampFactor/100)
			p.global_position += (Vector2.DOWN * (Gravity * 100)) * delta * delta
			p.previous_position = PositionBeforeUpdate
			
			if p.global_position.y > ProjectSettings.get_setting("display/window/size/viewport_height"):
				p.global_position.y = ProjectSettings.get_setting("display/window/size/viewport_height")
			
	for i in Iterations:
		for stick in StickContainer.get_children():
			var stickCenter = (stick.pointA.global_position + stick.pointB.global_position)/2
			var stickDirection = (stick.pointA.global_position - stick.pointB.global_position).normalized()
			
			if !stick.pointA.locked:
				stick.pointA.global_position = stickCenter + stickDirection * stick.length/2
			if !stick.pointB.locked:
				stick.pointB.global_position = stickCenter - stickDirection * stick.length/2
				
	if ShowDebug:
		queue_redraw()

func _draw():
	for stick in StickContainer.get_children():
		if stick.pointA and stick.pointB:
			draw_line(stick.pointA.position, stick.pointB.position, DrawColor, 1.0)
	
func add_point(position):
	var pointNode = Node2D.new()
	pointNode.name == "Point"
	pointNode.set_script(load("res://Scripts/Point.gd"))
	PointContainer.add_child(pointNode)
	pointNode.global_position = position
	pointNode.previous_position = position
	
	return pointNode
	
func add_stick(pointA, pointB, length):
	var stickNode = Node2D.new()
	stickNode.name == "Stick"
	stickNode.set_script(load("res://Scripts/Stick.gd"))
	StickContainer.add_child(stickNode)
	stickNode.pointA = pointA
	stickNode.pointB = pointB
	stickNode.length = length
	
	return add_stick
	
func get_nearest_point(position):
	var nearest_point
	var lowest_distance = 1000000000
	
	for p in PointContainer.get_children():
		var distance = p.global_position.distance_to(position)
		if distance < lowest_distance:
			nearest_point = p
			lowest_distance = distance
			
	return nearest_point
	
func get_nearest_stick(position):
	var nearest_stick
	var lowest_distance = 1000000000
	
	for stick in StickContainer.get_children():
		var distance = ((stick.pointA.global_position + stick.pointB.global_position)/2).distance_to(position)
		if distance < lowest_distance:
			nearest_stick = stick
			lowest_distance = distance
			
	return nearest_stick

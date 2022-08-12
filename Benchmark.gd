extends Node2D

var just_node = Node2D.new()
var resource = Theme.new()
var screen_width = 1024
var screen_height = 600
var half_size = 32
var speed = 0.01
var total_delta = 0
var direction = Vector2.UP
var rng = RandomNumberGenerator.new()
onready var nodes = $Nodes

func _ready():
	rng.randomize()
	update_labels()
	randomize_direction()

func _process(delta):
	$FPS.text = "FPS: %.00f" % Engine.get_frames_per_second()
	var sprite = $Sprite
	
	total_delta = total_delta + delta
	while total_delta > speed:
		total_delta = total_delta - speed
		sprite.translate(direction)
		if (sprite.position.x < half_size
				or sprite.position.y < half_size
				or sprite.position.x > screen_width - half_size
				or sprite.position.y > screen_height - half_size):
			randomize_direction()
	
	update_labels()

func _on_AddNodeButton_pressed():
	for i in range(5000):
		nodes.add_child(just_node.duplicate())
	update_labels()

func _on_AddObjectButton_pressed():
	for i in range(5000):
		just_node.duplicate()
	update_labels()

func _on_AddResourceButton_pressed():
	resource.duplicate(true)
	update_labels()

func randomize_direction():
	direction = Vector2.UP.rotated(rng.randf_range(.0, 2.0 * PI))

func update_labels():
	$MarginContainer/GridContainer/NodesLabel.text = "%.00f" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	$MarginContainer/GridContainer/ObjectsLabel.text = "%.00f" % Performance.get_monitor(Performance.OBJECT_COUNT)
	$MarginContainer/GridContainer/ResourcesLabel.text = "%.00f" % Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)
#	$MarginContainer/GridContainer/OrphanNodesLabel.text = "%.00f" % Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)

func _on_FreeNodes_pressed():
	nodes.queue_free()
	nodes = Node2D.new()
#	add_child(nodes)
	update_labels()
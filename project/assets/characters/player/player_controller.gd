extends KinematicBody


export(NodePath) var camera_path
onready var camera := get_node(camera_path) as Camera

export(float) var speed := 50.0


var current_direction : Vector3


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	process_input(delta)
	process_movement(delta)
		

func process_input(delta: float) -> void:
	# Reset direcion
	current_direction = Vector3()
	
	var camera_transform := camera.get_global_transform()
	
	if Input.is_action_pressed("move_forward"):
		current_direction -= camera_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		current_direction += camera_transform.basis.z
	if Input.is_action_pressed("move_left"):
		current_direction -= camera_transform.basis.x
	if Input.is_action_pressed("move_right"):
		current_direction += camera_transform.basis.x
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func process_movement(delta: float) -> void:
	move_and_slide(current_direction * speed, Vector3.UP)

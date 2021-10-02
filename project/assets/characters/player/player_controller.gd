extends KinematicBody


export(NodePath) var camera_path
onready var camera := get_node(camera_path) as Camera


export(float) var acceleration := 2.0
export(float) var deceleration := 8.0
export(float) var max_speed := 6.0
export(float) var rotation_speed := 70.0


var desired_direction: Vector3
var desired_rotation_direction: int
var current_velocity: Vector3


func _ready() -> void:
    pass


func _physics_process(delta: float) -> void:
    process_input(delta)
    process_movement(delta)
        

func process_input(_delta: float) -> void:
    # Reset direction
    desired_direction = Vector3()
    
    # Reset rotation
    desired_rotation_direction = 0
    
    var camera_transform := camera.get_global_transform()
    
    if Input.is_action_pressed("move_forward"):
        desired_direction -= camera_transform.basis.z
    if Input.is_action_pressed("move_backward"):
        desired_direction += camera_transform.basis.z
    if Input.is_action_pressed("rotate_left"):
        desired_rotation_direction = -1
    if Input.is_action_pressed("rotate_right"):
        desired_rotation_direction = 1
        

func process_movement(delta: float) -> void:            
    var new_velocity: Vector3
    if desired_direction.length() != 0:
        new_velocity = desired_direction * current_velocity.length()
        new_velocity = new_velocity.linear_interpolate(desired_direction * max_speed, acceleration * delta)
    else:
        new_velocity = current_velocity.linear_interpolate(Vector3(), deceleration * delta)
    
    rotate_y(deg2rad(rotation_speed * -desired_rotation_direction * delta))
    current_velocity = move_and_slide(new_velocity, Vector3.UP)

extends Spatial

export(float) var rotation_speed = 1.0
export(float) var max_rotation_angle = 45.0
var rot_angle_z = 0.0
var rot_angle_x = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rot_angle_z = 0.0
	rot_angle_x = 0.0
	
	var current_angle_z = rad2deg(get_transform().basis.get_euler().z)
	var current_angle_x = rad2deg(get_transform().basis.get_euler().x)
	
	if Input.is_action_pressed("tray_left") and current_angle_z < max_rotation_angle:
		rot_angle_z = rotation_speed * delta
	elif Input.is_action_pressed("tray_right") and current_angle_z > -max_rotation_angle:
		rot_angle_z = -rotation_speed * delta
		
	if Input.is_action_pressed("tray_front") and current_angle_x < max_rotation_angle:
		rot_angle_x = rotation_speed * delta
	elif Input.is_action_pressed("tray_back") and current_angle_x > -max_rotation_angle:
		rot_angle_x = -rotation_speed * delta

func _physics_process(_delta):
	rotate_z(rot_angle_z)
	rotate_x(rot_angle_x)

extends Spatial

export(float) var rotation_speed = 1.0
var rot_angle = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rot_angle = 0.0
	if Input.is_action_pressed("tray_left"):
		rot_angle = rotation_speed * delta
	elif Input.is_action_pressed("tray_right"):
		rot_angle = -rotation_speed * delta
	

func _physics_process(_delta):
	rotate_z(rot_angle)

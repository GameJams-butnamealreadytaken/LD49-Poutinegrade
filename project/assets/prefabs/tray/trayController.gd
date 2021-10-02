extends RigidBody

export(float) var rotation_speed = 1.0
export(float) var rotation_max = 45.0

var rot_angle_z = 0.0
var rot_angle_x = 0.0

var current_scale

# Called when the node enters the scene tree for the first time.
func _ready():
    current_scale = transform.basis.get_scale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    rot_angle_x = 0.0
    rot_angle_z = 0.0
    
    if mode == MODE_KINEMATIC:
        var rotation_x = abs(rad2deg(get_transform().basis.get_euler().x))
        var rotation_z = abs(rad2deg(get_transform().basis.get_euler().z))
        
        if rotation_x > rotation_max or rotation_z > rotation_max:
            mode = MODE_RIGID
    
        if Input.is_action_pressed("tray_front"):
            rot_angle_x = -rotation_speed * delta
        elif Input.is_action_pressed("tray_back"):
            rot_angle_x = rotation_speed * delta
            
        if Input.is_action_pressed("tray_left"):
            rot_angle_z = rotation_speed * delta
        elif Input.is_action_pressed("tray_right"):
            rot_angle_z = -rotation_speed * delta
            
    if Input.is_action_pressed("tray_reset"):
        resetTray()
    
func resetTray():
    mode = MODE_KINEMATIC
    
    transform.basis = Basis()
    transform = transform.basis.scaled(current_scale)

func _physics_process(_delta):
    if rot_angle_x != 0.0:
        rotate_x(rot_angle_x)
    if rot_angle_z != 0.0:
        rotate_z(rot_angle_z)

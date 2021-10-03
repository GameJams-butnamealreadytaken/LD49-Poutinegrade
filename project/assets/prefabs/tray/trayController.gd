extends RigidBody

class_name TrayController

signal onTrayBail

export(float) var rotation_speed = 1.0
export(float) var rotation_max = 30.0
export(float) var move_offset_speed = 0.1

var rot_angle_x = 0.0
var rot_angle_z = 0.0

var parent : Node
var current_scale : Vector3

var limit_rotation_counter: float


func _ready():
    current_scale = transform.basis.get_scale()
    parent = get_parent()    

func _process(delta):
    rot_angle_x = 0.0
    rot_angle_z = 0.0
    
    if mode == MODE_KINEMATIC:
        if Input.is_action_pressed("tray_front"):
            rot_angle_x = -rotation_speed * delta
        elif Input.is_action_pressed("tray_back"):
            rot_angle_x = rotation_speed * delta
            
        if Input.is_action_pressed("tray_left"):
            rot_angle_z = rotation_speed * delta
        elif Input.is_action_pressed("tray_right"):
            rot_angle_z = -rotation_speed * delta
            
        var rotation_x = rad2deg(get_transform().basis.get_euler().x)
        var rotation_z = rad2deg(get_transform().basis.get_euler().z)
        
        if rot_angle_x == 0.0 and rot_angle_z == 0.0:
            limit_rotation_counter = 0.0
            
        if abs(rotation_x) > rotation_max and rot_angle_x != 0.0:
            limit_rotation_counter += delta
            if (rotation_x < 0 and rot_angle_x < 0) or rotation_x > 0 and rot_angle_x > 0:
                rot_angle_x = 0.0
        if abs(rotation_z) > rotation_max and rot_angle_z != 0.0:
            limit_rotation_counter += delta
            if (rotation_z < 0 and rot_angle_z < 0) or rotation_z > 0 and rot_angle_z > 0:
                rot_angle_z = 0.0
         
        if limit_rotation_counter > 1.0 and (abs(rotation_x) > rotation_max or abs(rotation_z) > rotation_max):
            mode = MODE_RIGID
            var transfo = global_transform
            var root = get_tree().get_root()
            parent.remove_child(self)
            root.add_child(self)
            transform = transfo
            emit_signal("onTrayBail")
            
    if Input.is_action_just_pressed("tray_reset"):
        resetTray()
    
func resetTray():
    get_parent().remove_child(self)
    parent.add_child(self)
    mode = MODE_KINEMATIC
    transform.basis = Basis()
    transform = transform.basis.scaled(current_scale)
    limit_rotation_counter = 0.0

func _physics_process(_delta):
    if rot_angle_x != 0.0:
        rotate_x(rot_angle_x)
    if rot_angle_z != 0.0:
        rotate_z(rot_angle_z)

func on_player_moved(direction: int, rotation: int, delta: float) -> void:
    if mode != MODE_KINEMATIC:
        return
        
    var rotation_x = abs(rad2deg(get_transform().basis.get_euler().x))
    var rotation_z = abs(rad2deg(get_transform().basis.get_euler().z))
    
    if abs(rotation_x) < rotation_max:
        if direction == 1:
            rot_angle_x -= move_offset_speed * delta
        elif direction == -1:
            rot_angle_x += move_offset_speed * delta
    
    if abs(rotation_z) < rotation_max:
        if rotation == 1:
            rot_angle_z += move_offset_speed * delta
        elif rotation == -1:
            rot_angle_z -= move_offset_speed * delta

func is_in_kinematic_state() -> bool:
    return mode == MODE_KINEMATIC

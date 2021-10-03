extends KinematicBody

class_name Player

export(NodePath) var camera_path
onready var camera := get_node(camera_path) as Camera

export(NodePath) var tray_anchor_path
onready var tray_anchor := get_node(tray_anchor_path) as Position3D

export(NodePath) var interactable_detector_path
onready var interactable_detector := get_node(interactable_detector_path) as RayCast

export(PackedScene) var hud_scene: PackedScene
export(PackedScene) var tray_scene: PackedScene

export(float) var acceleration := 2.0
export(float) var deceleration := 8.0
export(float) var max_speed := 6.0
export(float) var run_speed_ratio := 2
export(float) var rotation_speed := 70.0


var hud: PlayerHUD

var money: float = 0.0

var tray: TrayManager

var desired_direction: Vector3
var desired_rotation_direction: int
var last_velocity: Vector3
var current_velocity: Vector3

var nearest_interactable: Interactable

var game_finished: bool

var use_run_ratio: bool


func _ready() -> void:
    tray = tray_scene.instance()
    tray_anchor.add_child(tray)
    
    game_finished = false
    
    hud = hud_scene.instance() as PlayerHUD
    add_child(hud)

func reset():
    game_finished = false
    money = 0

func _physics_process(delta: float) -> void:  
    if not Game.started:
        return
        
    if game_finished:
        return
         
    process_input(delta)
    process_movement(delta)
    process_raycasts(delta)
    update_hud(delta)
    

func process_input(delta: float) -> void:         
    # Reset direction
    desired_direction = Vector3()
    
    # Reset rotation
    desired_rotation_direction = 0
    
    var camera_transform := camera.get_global_transform()
    var direction = 0 as int
    
    # Movement inputs
    if Input.is_action_pressed("move_forward"):
        direction = -1
    if Input.is_action_pressed("move_backward"):
        direction = 1
    if Input.is_action_pressed("rotate_left"):
        desired_rotation_direction = -1
    if Input.is_action_pressed("rotate_right"):
        desired_rotation_direction = 1
    
    use_run_ratio = Input.is_action_pressed("run")
    if use_run_ratio == true:
        tray.trigger_bail()
    
    desired_direction += direction * camera_transform.basis.z
    
    tray.on_player_moved(direction, desired_rotation_direction, delta)
    
    # Interaction input
    if Input.is_action_just_pressed("interact") and nearest_interactable != null:
        nearest_interactable.interact(self)
        

func process_movement(delta: float) -> void:            
    var new_velocity: Vector3
    if desired_direction.length() != 0:
        new_velocity = desired_direction * current_velocity.length()
        var max_speed_dir = desired_direction * max_speed
        if use_run_ratio:
            max_speed_dir *= run_speed_ratio
        new_velocity = new_velocity.linear_interpolate(max_speed_dir, acceleration * delta)
    else:
        new_velocity = current_velocity.linear_interpolate(Vector3(), deceleration * delta)
    
    var rotaval = deg2rad(rotation_speed * -desired_rotation_direction * delta)
    
    if rotaval != 0.0:
        rotate_y(rotaval)
        
    last_velocity = current_velocity
    current_velocity = move_and_slide(new_velocity, Vector3.UP)

func process_raycasts(_delta: float) -> void:
    if tray and !tray.is_in_kinematic_state():
        nearest_interactable = null
        return
    
    nearest_interactable = interactable_detector.get_collider() as Interactable


func update_hud(_delta: float) -> void:
    if nearest_interactable != null:
        hud.set_interaction_text(nearest_interactable.display_text)
    else:
        hud.set_interaction_text("")

func UpdateMoney(amount: int):
    money += amount
    hud.set_label_money_value(String(money))

func game_finished():
    game_finished = true
    hud.show_game_finished()

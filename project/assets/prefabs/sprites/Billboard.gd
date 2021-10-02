extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var CameraToLookAt = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    CameraToLookAt = get_parent().find_node("Camera", true)
    if not CameraToLookAt == null:
        var pos = CameraToLookAt.transform.origin
        pos.y = 0
        var rot = rotation_degrees
        transform = transform.looking_at(pos, Vector3(0.0, 1.0, 0.0))
        var rot2 = rotation_degrees
        var rot4 = "sdf"

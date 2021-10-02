extends Spatial

class_name Customer

# var forwarded
export(String, "Adventurer", "Man", "ManAlternative", "Orc", "Robot", "Soldier", "Woman", "WomanAlternative") var CharacterType

# var
var RequestedFoodScene : PackedScene
var RequestedFood : Food
var Idle = true
var Valid = false
export var IdleThresholdMin = 1
export var IdleThresholdMax = 30
var Rnd = RandomNumberGenerator.new()
var IdleThreshold # updated at each new Idle state
var IdleElapsedTime = 0
var customerManager = null

# Called when the node enters the scene tree for the first time.
func _ready():

    # Random Idle threshold
    Rnd.randomize()
    IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax)
    
    # Setup customer material
    $sceneCharacter.SetCharacterType(CharacterType)
    $sceneCharacter.SetupMaterials()
    
    customerManager = get_parent() as CustomerManager
    if customerManager == null:
        print("Cannot create customer, parent node does not possess script 'CustomerManager'.")
        return
        
    Valid = true
    
    RequestedFoodScene = null
    RequestedFood = null
    
    # Register customer
    customerManager.RegisterCustomer(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if !Valid:
        return
        
    if Idle:
        IdleElapsedTime += delta
        if IdleElapsedTime >= IdleThreshold:
            IdleElapsedTime = 0
            SwitchState()
    return

func IsIdle():
    return Idle;
    
func IsRequesting():
    return !Idle

func ServeRequestedFood(food):
    var foodObject = food  as Food
    if foodObject == null:
        return
    elif Idle:
        return
    elif not foodObject.food_name == RequestedFood.food_name:
        return
    
    # Remove requested item and switch state
    RequestedFoodScene = null
    RequestedFood = null
    
    SwitchState()
        
func RequestNewFood(foodScene: PackedScene):
    if !Idle:
        return
    
    # Update requested food
    RequestedFoodScene = foodScene
    RequestedFood = RequestedFoodScene.instance() as Food
    add_child(RequestedFood)
    
    # Update visualization
    var character = find_node("character", true, false)
    var offset = Vector3(8, 13, 0)
    var scale = Vector3(8, 8, 8)
    RequestedFood.global_transform = character.global_transform
    RequestedFood.translate(offset)
    RequestedFood.global_scale(scale)
    RequestedFood.make_food_static()
    
func SwitchState():
    # Notify CustomerManager
    customerManager.OnCustomerSwitchedState(self, Idle)
    
    # Updte Idle
    Idle = !Idle
    
    # Update idle threshold
    if !Idle:
        IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax)

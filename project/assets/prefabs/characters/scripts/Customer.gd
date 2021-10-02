extends Spatial

class_name Customer

# var forwarded
export(String, "Adventurer", "Man", "ManAlternative", "Orc", "Robot", "Soldier", "Woman", "WomanAlternative") var CharacterType

# var
var RequestedFoodItem = null
var Idle = true
var Valid = false
export var IdleThresholdMin = 1
export var IdleThresholdMax = 30
var Rnd = RandomNumberGenerator.new()
var IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax) # Is then updated at each new Idle state
var IdleElapsedTime = 0
var customerManager = null

# Called when the node enters the scene tree for the first time.
func _ready():
        
    # Setup customer material
    $sceneCharacter.SetCharacterType(CharacterType)
    $sceneCharacter.SetupMaterials()
    
    customerManager = get_parent() as CustomerManager
    if customerManager == null:
        print("Cannot create customer, parent node does not possess script 'CustomerManager'.")
        return
        
    Valid = true
    
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

func ServeRequestItem(item):
    var itemObject = item as Food
    if itemObject == null:
        return
    elif Idle:
        return
    elif not itemObject.food_name == RequestedFoodItem.food_name:
        return
    
    # Remove requested item and switch state
    RequestedFoodItem = null
    SwitchState()
        
func RequestItem(item):
    var itemObject = item as Food
    if itemObject == null:
        return
    elif !Idle:
        return
    
    # Update requested item
    RequestedFoodItem = itemObject
    
    # Update visualization
    var side_decal = $sceneCharacter/character.position().x + 1
    var sceneFood = load("res://")
    
func SwitchState():
    Idle = !Idle
    
    # Update idle threshold
    if !Idle:
        IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax)
    
    # Notify CustomerManager
    customerManager.OnCustomerSwitchedState(self, Idle)

extends Spatial

# var forwarded
export(String, "Adventurer", "Man", "ManAlternative", "Orc", "Robot", "Soldier", "Woman", "WomanAlternative") var CharacterType

# var
var RequestedMenuItem = null
var Idle = true
var Valid = false
export var IdleThresholdMin = 1
export var IdleThresholdMax = 30
var Rnd = RandomNumberGenerator.new()
var IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax) # Is then updated at each new Idle state
var IdleElapsedTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
        
    # Setup customer material
    $sceneCharacter.SetCharacterType(CharacterType)
    $sceneCharacter.SetupMaterials()
    
    if get_parent().get_script() == null:
        print("Cannot create customer, parent node does not possess script 'CustomerManager'.")
    elif not get_parent().get_script().get_path() == "res://assets/prefabs/managers/CustomerManager.gd":
        print("Cannot create customer, parent node does not possess script 'CustomerManager'.")
    elif $sceneCharacter.get_script() == null:
        print("Cannot create customer, child node does not possess script 'CharacterChooser'.")
    elif not $sceneCharacter.get_script().get_path() == "res://assets/prefabs/characters/scripts/CharacterChooser.gd":
        print("Cannot create customer, child node does not possess script 'CharacterChooser'.")
    else:
        Valid = true
        
        # Register customer
        get_parent().RegisterCustomer(self)

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

func IsFoodItemObjectValid(item):
    return true
    #return item != null and item.is_class("FoodItem")
        
func ServeRequestItem(item):
    if not IsFoodItemObjectValid(item):
        return
    elif Idle:
        return
    elif not item.GetFoodType() == RequestedMenuItem.GetFoodType():
        return
    
    # Remove requested item and switch state
    RequestedMenuItem = null
    SwitchState()

func SwitchState():
    Idle = !Idle
    
    # Update idle threshold
    if !Idle:
        IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax)
    
    # Notify CustomerManager
    get_parent().OnCustomerSwitchedState(self, Idle)

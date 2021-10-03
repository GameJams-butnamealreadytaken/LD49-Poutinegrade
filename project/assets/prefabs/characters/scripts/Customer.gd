extends Interactable

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
export var RequestingThresholdMin = 20
export var RequestingThresholdMax = 30
var Rnd = RandomNumberGenerator.new()
var IdleThreshold # updated at each new Idle state
var RequestingThreshold # updated at each new Idle state
var ElapsedTime = 0
var FoodAnimationOffsetThreshold = 3
var FoodAnimationOffset = 0
var FoodAnimationInitialPos : Vector3

var customerManager = null
var player = null

func IsCustomerManagerObjectValid(_customerManager):
    return _customerManager != null and _customerManager.get_script() != null and customerManager.get_script().get_path() == "res://assets/prefabs/managers/CustomerManager.gd"
     
# Called when the node enters the scene tree for the first time.
func _ready():

    # Random Idle threshold
    Rnd.randomize()
    IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax)
    
    # Setup customer material
    $sceneCharacter.SetCharacterType(CharacterType)
    $sceneCharacter.SetupMaterials()
    
    customerManager = get_parent()
    if not IsCustomerManagerObjectValid(customerManager):
        print("Cannot create customer, parent node does not possess script 'CustomerManager'.")
        return
        
    Valid = true
    
    RequestedFoodScene = null
    RequestedFood = null
    
    # Register customer
    customerManager.RegisterCustomer(self)
    var mat = $spriteTimer.get_material_override().duplicate(true)
    $spriteTimer.set_material_override(mat)
    $spriteTimer.set_visible(false)

func reset():
    Valid = false
    ElapsedTime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not Game.started:
        reset()
        return
        
    if !Valid:
        return
        
    ElapsedTime += delta
    if Idle:
        if ElapsedTime >= IdleThreshold:
            ElapsedTime = 0
            SwitchState()
    else:
        # Animation of the requested food
        RequestedFood.global_rotate(Vector3(0.0, 1.0, 0.0), delta * 0.5)
        RequestedFood.global_transform.origin = FoodAnimationInitialPos + Vector3(0.0, 0.25, 0.0) * sin(ElapsedTime)
        if ElapsedTime >= RequestingThreshold:
            ElapsedTime = 0
            ServeRequestedFood(null)
        else:
            var mat = $spriteTimer.get_material_override()
            mat.set_shader_param("elapsed_time", ElapsedTime)

func IsIdle():
    return Idle;
    
func IsRequesting():
    return !Idle

func ServeRequestedFood(food: Food):
    if Idle:
        return
        
    var keepRequestingFood = false
    var foodServedMultiplier = 1
    if food == null: # requesting time reached
        foodServedMultiplier = -1
    elif not food.food_name == RequestedFood.food_name:
        keepRequestingFood = true
        foodServedMultiplier = -0.5
    
    # Update money
    customerManager.OnCustomerFoodJustServed(food, foodServedMultiplier)
        
    if not keepRequestingFood:
        # Remove requested item and switch state
        RequestedFoodScene = null
        RequestedFood.queue_free()
        RequestedFood = null
    
        # Switch State
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
    var offset = Vector3(0, 20, 0)
    var scale = Vector3(7, 7, 7)
    RequestedFood.global_transform = character.global_transform
    RequestedFood.translate(offset)
    RequestedFood.global_scale(scale)
    RequestedFood.make_food_static()
    FoodAnimationInitialPos = RequestedFood.global_transform.origin
    
func SwitchState():
    # Notify CustomerManager
    customerManager.OnCustomerSwitchedState(self, Idle)
    
    # Update Idle
    Idle = !Idle
    
    # Update idle threshold
    if Idle:
        IdleThreshold = Rnd.randi_range(IdleThresholdMin, IdleThresholdMax)
        $spriteTimer.set_visible(false)
    else:
        RequestingThreshold = Rnd.randi_range(RequestingThresholdMin, RequestingThresholdMax)        
        $spriteTimer.set_visible(true)
        var mat = $spriteTimer.get_material_override()
        mat.set_shader_param("elapsed_time", 0)
        mat.set_shader_param("total_time", RequestingThreshold)
        

func interact(_instigator: Player):
    if RequestedFood == null:
        return
        
    var tray_food = _instigator.tray.get_food_object(RequestedFood.food_name)
    
    if tray_food != null:
        ServeRequestedFood(tray_food)
        tray_food.queue_free()

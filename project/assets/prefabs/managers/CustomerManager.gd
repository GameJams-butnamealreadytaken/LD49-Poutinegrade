extends Node

class_name CustomerManager

# var
var CustomersArray = []
var CustomersStateArray = [[],[]] # Double array with [0] = idle / [1] = requesting
var rng = RandomNumberGenerator.new()

# Variables set by the script 'restaurant'
var player = null
var AvailableFoodSpawners = []

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    if not Game.started:
        CustomersStateArray[0].clear()
        CustomersStateArray[1].clear()
        CustomersStateArray[0].append_array(CustomersArray)

func IsCustomerObjectValid(customer):
    return customer != null and customer.get_script().get_path() == "res://assets/prefabs/characters/scripts/Customer.gd"
        
func RegisterCustomer(customer):
    if not IsCustomerObjectValid(customer):
        return
        
    CustomersArray.append(customer)
    CustomersStateArray[0].append(customer)
    
    #print_debug("New customer: "+customer.to_string())

func UnregisterCustomer(customer):
    if not IsCustomerObjectValid(customer):
        return
        
    var iFindIndex = CustomersArray.find(customer)
    if iFindIndex != -1:
        CustomersArray.remove(iFindIndex)
        #print_debug("Removed customer: "+customer.to_string())

func GetCustomersCount():
    return CustomersArray.size()
    
func GetCustomersRequestingCount():
    return CustomersStateArray[1].size()
    
func GetCustomersIdleCount():
    return CustomersStateArray[0].size()

func OnCustomerSwitchedState(customer, newState):
    if not IsCustomerObjectValid(customer):
        return
        
    # Custom action according to new state
    if newState:
        customer.RequestNewFood(OnCustomerRequestingNewFood().food_to_spawn)

    # Remove customer from current state array
    var iNewState = int(newState)
    var iOldState = int(!newState)
    var iFindIndex = CustomersStateArray[iOldState].find(customer)
    if iFindIndex == -1:
        #print_debug("Error, trying to remove a customer from '"+oldState+("' and it is not inside array"))
        pass
    else:
        CustomersStateArray[iOldState].remove(iFindIndex)
        
    # Add customer in new state array
    CustomersStateArray[iNewState].append(customer)
 #   print_debug("Customer '"+customer.to_string()+"' switched state to '"+newState+"'")

    # Update HUD values
    player.hud.set_label_clients_requesting_value(String(CustomersStateArray[1].size()))
    
    
func OnCustomerRequestingNewFood():
    rng.randomize()
    var foodSpawnerIndex = rng.randi_range(0, AvailableFoodSpawners.size()-1)
    return AvailableFoodSpawners[foodSpawnerIndex]

func OnCustomerFoodJustServed(requestedFood, multiplier: float):
    var reward = 1.0
    if requestedFood == null:
        reward = 5
    else:
        reward = requestedFood.food_reward
    player.UpdateMoney(int(reward * multiplier))
    
func SetAvailableFoodSpawners(foodSpawners):
    AvailableFoodSpawners = foodSpawners

func ValidateCustomers():
    var count = CustomersArray.size()
    for i in range(0, count-1):
        CustomersArray[i].Valid = true

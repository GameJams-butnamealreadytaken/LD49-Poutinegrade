extends Node

class_name CustomerManager

# var
var CustomersArray = []
var CustomersStateArray = [[],[]] # Double array with [0] = idle / [1] = requesting

var HUD = null

# Called when the node enters the scene tree for the first time.
func _ready():
    var possiblePlayers = get_tree().get_nodes_in_group("player")
    if possiblePlayers.empty():
       return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

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
    HUD.set_label_clients_requesting_value(String(CustomersStateArray[1].size()))

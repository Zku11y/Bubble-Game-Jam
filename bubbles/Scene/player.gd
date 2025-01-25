extends CharacterBody2D
@onready var timer: Timer = $Bubble_time
@onready var bubbles: Node2D = $"../CanvasLayer/Bubbles"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum states {normal_idle, normal_move, heavy_idle, heavy_move}

var state := states.normal_idle
var direction_lr
var direction_ud
var bubble_count = []
var dmg_taken = 0
var bubbles_taken = 0

func _ready() -> void:
	for i in range(0, 10):
		bubble_count.append(bubbles.get_child(i))


func _physics_process(delta: float) -> void:
	#print(timer.time_left)
	if timer.time_left < 0.2:
		print("timeout! ", timer.time_left)
		_bubble_manage()
	direction_lr = Input.get_axis("left", "right")
	direction_ud = Input.get_axis("up", "down")
	_set_state()
	_define_state()
	move_and_slide()
	if Input.is_action_just_pressed("remove"):
		dmg_taken = 1
	if Input.is_action_just_pressed("add"):
		bubbles_taken = 1
	
func _set_state():
	# add condition !pickup to switch between normal pickup and non pickup
	state = states.normal_move
	
	
	# add the movement state when picking up items

func _bubble_manage():
	var current_bubble := 0
	for i in range(0, 10):
		if bubble_count[i].visible:
			break
		current_bubble += 1
	if timer.timeout:
		if current_bubble >= 10:
			return
		else:
			timer.start(3)
			bubble_count[current_bubble].visible = false
			if current_bubble < 9:
				current_bubble += 1
	elif dmg_taken:
		for i in range(current_bubble, current_bubble + dmg_taken):
			if i >= 10:
				break
			bubble_count[i].visible = false
		dmg_taken = 0

	elif bubbles_taken:
		if current_bubble - 1 >= 0:
			bubble_count[current_bubble - 1].visible = true
		bubbles_taken = 0


func _define_state():
	if state == states.normal_move:
		if direction_lr:
			velocity.x = direction_lr * SPEED
		if direction_ud:
			velocity.y = direction_ud * SPEED
		if !direction_lr:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if !direction_ud:
			velocity.y = move_toward(velocity.y, 0, SPEED)

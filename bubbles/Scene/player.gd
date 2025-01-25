extends CharacterBody2D
@onready var timer: Timer = $Bubble_time
@onready var bubbles: Node2D = $"../CanvasLayer/Bubbles"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_BUBBLES = 10

enum states {normal_idle, normal_move, heavy_idle, heavy_move}

var state := states.normal_idle
var direction_lr
var direction_ud
var bubble_count = []
var bubble_index := 0
var dmg_taken
var bubble_taken
var is_bubble_manage_running := false

func _ready() -> void:  
	for i in range(0, 10):
		bubble_count.append(bubbles.get_child(i))
	timer.start()

func _process(delta: float) -> void:
	#print(timer.time_left)
	direction_lr = Input.get_axis("left", "right")
	direction_ud = Input.get_axis("up", "down")
	_set_state()
	_define_state()
	_bubble_dmg()
	_bubble_take()
	move_and_slide()
	dmg_taken = Input.is_action_just_pressed("remove")
	bubble_taken = Input.is_action_just_pressed("add")
	_bubble_manage()

func _bubble_dmg():
	if dmg_taken && bubble_index < 9:
		bubble_count[bubble_index].visible = false
		bubble_index += 1

func _bubble_take():
	if bubble_taken && bubble_index > 0:
		bubble_index -= 1
		bubble_count[bubble_index].visible = true

func _bubble_manage():
	if is_bubble_manage_running:
		return
	is_bubble_manage_running = true
	await get_tree().create_timer(2).timeout
	print(bubble_index)
	if bubble_index >= MAX_BUBBLES:
		is_bubble_manage_running = false
		return
	bubble_count[bubble_index].visible = false
	bubble_index += 1
	is_bubble_manage_running = false


	
func _set_state():
	# add condition !pickup to switch between normal pickup and non pickup
	state = states.normal_move
	
	
	# add the movement state when picking up items

	
	
	#if timer.time_left <= (18.0 - (bubble_index * 2)):
		#if timer.time_left == 0:
			#return # add gameover screen and restart mechanic
		#bubble_count[bubble_index].visible = false
		#bubble_index += 1
	#
	#if dmg_taken:
		#var temp_time = timer.time_left - (dmg_taken * bubble_index * 2)
		#if temp_time <= 0:
			#return
		#timer.stop()
		#timer.start(temp_time)
		#for i in range(bubble_index, bubble_index + dmg_taken):
			#bubble_count[i].visible = false
	#
	#if bubble_taken:
		#var temp_time = timer.time_left + (bubble_taken * bubble_index * 2)
		#if temp_time > 18.0:
			#return
		#timer.stop()
		#timer.start(temp_time)
		#for i in range(bubble_index, bubble_index - bubble_taken):
			#if !bubble_count[i].visible:
				#bubble_count[i].visible = true
	#var current_bubble := 0
	#for i in range(0, 10):
		#if bubble_count[i].visible:
			#break
		#current_bubble += 1
	#if timer.timeout:
		#if current_bubble >= 10:
			#return
		#else:
			#timer.start(2)
			#bubble_count[current_bubble].visible = false
			#if current_bubble < 9:
				#current_bubble += 1
	#elif dmg_taken:
		#for i in range(current_bubble, current_bubble + dmg_taken):
			#if i >= 10:
				#break
			#bubble_count[i].visible = false
		#dmg_taken = 0
#
	#elif bubble_taken:
		#if current_bubble - 1 >= 0:
			#bubble_count[current_bubble - 1].visible = true
		#bubble_taken = 0


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

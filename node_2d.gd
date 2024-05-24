extends Node2D

var grid_pos: Vector2i
var board_size: int
var cell_size: int
var grid_data : Array
var player: int
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int
var winner: int
var moves: int

# Called when the node enters the scene tree for the first time.
func _ready():
	board_size = $Board.texture.get_width()
	cell_size = board_size/3
	new_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < board_size:
				grid_pos = Vector2i(event.position / cell_size)
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					moves += 1
					grid_data[grid_pos.y][grid_pos.x] = player
					#place that player's marker
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2 + 10, cell_size / 2))
					if check_win() != 0:
						get_tree().paused = true
						#$.show()
						$GameOverMenu.visible = true
						if winner == 1:
							$GameOverMenu/Result.text = str("Player 1 Wins!")
						elif winner == -1:
							$GameOverMenu/Result.text = str("Player 2 Wins!")
					#check if the board has been filled
					elif moves == 9:
						get_tree().paused = true
						$GameOverMenu.visible = true
						$GameOverMenu/Result.text = str("It's a Tie!")
						#$GameOverMenu.show()
						#$GameOverMenu.get_node("ResultLabel").text = "It's a Tie!"
					player *= -1
					#update the panel marker
					#temp_marker.queue_free()
					#create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
					print(grid_data)

func new_game():
	player = 1
	row_sum = 0
	col_sum = 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	winner = 0
	moves = 0

	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]

	$GameOverMenu.visible = false
	get_tree().paused = false

	var children_to_remove = []
	for child in get_children():
		if child.is_in_group("markers"):
			children_to_remove.append(child)

	for child in children_to_remove:
		remove_child(child)
		child.queue_free()

func create_marker(player, position):
	var marker
	if player == 1:
		marker = $O.duplicate()
		marker.position = position
		add_child(marker)
	else:
		marker = $X.duplicate()
		marker.position = position
		add_child(marker)
	marker.add_to_group("markers")

func check_win():
	#add up the markers in each ros, column and diagonal
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
	
		#check if either player has all of the markers in one line
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner

func _on_btn_restart_pressed():
	new_game()

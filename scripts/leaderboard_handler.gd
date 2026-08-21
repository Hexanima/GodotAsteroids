extends Node2D

var leaderboard = {}

func handle_add_points(id: int, points: int) -> void:
	var current_points = leaderboard.get(id)
	var new_points = (current_points if current_points is int else 0) + points
	leaderboard.set(id, new_points)

func get_leaderboard() -> Array:
	var list = []
	
	for player_id in leaderboard:
		list.append({
			"id": player_id,
			"points": leaderboard[player_id]
		})
	
	list.sort_custom(func(a, b): return a["points"] > b["points"])
	
	return list
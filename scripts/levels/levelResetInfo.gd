extends Node2D

func _ready():
	GameManager.score = 0
	GameManager.maxScore = get_node("Coins").get_child_count()
	GameManager.nextLevel = get_meta("nextLevel")

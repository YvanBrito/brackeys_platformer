extends Node

var maxScore
var score = 0
var fruit = false
var nextLevel

func add_point():
	score += 1
	if score == maxScore:
		fruit = true
		
func go_to_next_level():
	get_tree().change_scene_to_file(nextLevel)

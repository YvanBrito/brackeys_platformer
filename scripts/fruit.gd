extends Area2D

var animated_sprite

func _ready():
	animated_sprite = get_parent().get_node("AnimatedSprite2D")

func _process(delta):
	if GameManager.fruit == true and monitoring == false:
		monitoring = true
		animated_sprite.modulate = Color(1,1,1,1)

func _on_body_entered(body):
	GameManager.go_to_next_level()

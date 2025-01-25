extends CharacterBody2D

@export var player: CharacterBody2D

@onready var anim = get_node("anim")

var speed : int = 3000

var inv = 1

enum mobState {
	IDLE,
	CHASING,
	ATTACKING,
	DEATH
}

var current_state

func _ready():
	current_state = mobState["IDLE"]

func _physics_process(delta):
	if is_instance_valid(player):
		var direction = (player.global_position - self.global_position).normalized()*inv
		match current_state:
			mobState["IDLE"]:
				anim.play("idle")
				velocity = Vector2(0,0)
			mobState["CHASING"]:
				anim.play("move")
				velocity = direction*speed*delta
			mobState["ATTACKING"]:
				anim.play("move")
				velocity = Vector2(0,0)
			mobState["DEATH"]:
				$AnimationPlayer.play("death")
				velocity = Vector2(0,0)
		if direction.x < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
		move_and_slide()


func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		current_state = mobState["CHASING"]
		
func _on_hit_body_entered(body):
	if body.is_in_group("player"):
		inv = -1
		
func _on_attack_detector_body_exited(body):
	if body.is_in_group("player"):
		inv = 1

extends CharacterBody2D

@export var player: CharacterBody2D

@onready var anim = get_node("anim")
@onready var hitDetection = get_node("hitDetection/CollisionShape2D")

var speed : int = 3000

enum mobState {
	IDLE,
	CHASING,
	ATTACKING,
	DEATH
}

var current_state
var damage:int = 1

func _ready():
	current_state = mobState["IDLE"]
	
func _physics_process(delta):
	if is_instance_valid(player):
		var direction = (player.global_position - self.global_position).normalized()
		
		match current_state:
			mobState["IDLE"]:
				anim.play("idle_down")
				velocity = Vector2(0,0)
				
			mobState["CHASING"]:
				$AnimationPlayer.play("walk")
				
				velocity = direction*speed*delta
			mobState["ATTACKING"]:
				$AnimationPlayer.play("attack")
				velocity = Vector2(0,0)
				
			mobState["DEATH"]:
				anim.play("death")
				velocity = Vector2(0,0)
		if direction.x < 0:
			anim.flip_h = true
			hitDetection.position = Vector2(-10,2)
		else:
			anim.flip_h = false
			hitDetection.position = Vector2(10,2)
		move_and_slide()

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		current_state = mobState["CHASING"]


func _on_attacking_detection_body_entered(body):
	if body.is_in_group("player"):
		current_state = mobState["ATTACKING"]

func _on_attacking_detection_body_exited(body):
	if body.is_in_group("player"):
		current_state = mobState["CHASING"]

func _on_hit_detection_body_entered(body):
	if body.is_in_group("player"):
		body.hit(damage)

extends CharacterBody2D

@onready var anim_tree = get_node("AnimationTree")
@onready var walking_sound = get_node("walking_sound")

var attacking:bool = false
var dying:bool = false
var health:int = 4
var speed = 5500
var counter = 0


func player():
	pass

func _ready():
	pass

func _physics_process(delta):
	
	var current_scene = get_tree().current_scene
	
	if Input.is_action_just_pressed("atack"):
		
		anim_tree.get("parameters/playback").travel("atack")
		attacking = true
		speed = 0
		if $attack_sound.playing == false:
				$attack_sound.play()
				
	if (attacking == false) and (dying == false):
		$attack_sound.stop()
		speed = 5500
		var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
		
		self.velocity = input_vector*delta*speed
		if input_vector == Vector2.ZERO:
			anim_tree.get("parameters/playback").travel("idle")
			walking_sound.stop()
		else:
			if walking_sound.playing == false:
				walking_sound.play()
			anim_tree.get("parameters/playback").travel("walk")
			anim_tree.set("parameters/idle/BlendSpace2D/blend_position", input_vector)
			anim_tree.set("parameters/atack/BlendSpace2D/blend_position", input_vector)
			anim_tree.set("parameters/walk/BlendSpace2D/blend_position", input_vector)
		

		
	move_and_slide()

func _on_animation_tree_animation_finished(anim_name):
	if "atack" in anim_name:
		attacking = false
		
func hit(damage):
	health -= damage
	if health <= 0:
		dying = true
		anim_tree.get("parameters/playback").travel("death_")
		await anim_tree.animation_finished
		get_node("AnimatedSprite2D").queue_free()
		get_node("../GameOverScreen").game_over()


func _on_attack_detector_area_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()




func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/cave1.tscn")




func _on_end_level_body_entered(body):
	var counter = counter+1
	if counter == 5:
		print("YOU WIN")
	else:
		get_tree().change_scene_to_file("res://scenes/cave_" + str(randi() % 4 + 1) + ".tscn")

extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$hpbar.max_value = get_node("../player").health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$hpbar.value = get_node("../player").health
		

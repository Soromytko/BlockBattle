extends ColorRect

func _process(delta):
	var fps : float = Engine.get_frames_per_second()
	var good : float = 60
	var r : float = max(0, 1 - fps / 60)
	var g : float = max(0, fps / 60)
	color = Color(r, g, 0, 0.5)
	$Label.text = str(fps)

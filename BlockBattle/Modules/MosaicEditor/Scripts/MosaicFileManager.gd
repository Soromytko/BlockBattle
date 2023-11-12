class_name MosaicFileManager


static func save_as_scene(root : Node2D, path : String = "res://Modules/MosaicEditor/Untitled.tscn"):
	var sandbox : MosaicSandbox = root
	var scene : PackedScene = PackedScene.new()
	var result = scene.pack(root)
	if 	result == OK:
		var error = ResourceSaver.save(path, scene)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")


static func load_as_scene(path : String = "res://Modules/MosaicEditor/Untitled.tscn") -> Node2D:
	var scene : Resource = load(path)
	return scene.instance()

extends AudioStreamPlayer

export (String) var sounds_path

func play_random_sound(sfx_path: String) -> void:
	var sfx = list_sounds_in_directory(sounds_path + sfx_path + "/")
	var sfx_idx : int

	if sfx.size() > 1:
		randomize()
		sfx_idx = randi() % sfx.size()
	else:
		sfx_idx = 0

	stream = sfx[sfx_idx]
	play()

func get_file_paths_in_folder(folder_path: String) -> Array:
	var file_paths := []
	
	var dir := Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin(true, true)
	
	while true:
		var file := dir.get_next()
		if file == "":
			break
		if !file.ends_with(".import"):
			continue
		file_paths.append(folder_path + file.replace(".import", ""))

	dir.list_dir_end()

	return file_paths

func list_sounds_in_directory(path) -> Array:
	var sounds = []

	for sound in get_file_paths_in_folder(path):
		sounds.append(load(sound))

	return sounds

func _on_sfx_finished() -> void:
	queue_free()

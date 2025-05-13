extends RichTextLabel

# Keep track of log lines and their timestamps
var log_lines = []
# Max duration a line stays on screen (in seconds)
const LINE_LIFETIME := 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_cleanup_old_lines()

func _cleanup_old_lines():
	var current_time = Time.get_ticks_msec() / 1000.0
	# Keep only lines that haven't expired
	log_lines = log_lines.filter(func(line): return current_time - line.time < LINE_LIFETIME)
	_update_text()

func add_log_line(text: String):
	var timestamp = Time.get_ticks_msec() / 1000.0  # Get current time in seconds
	log_lines.append({ "text": text, "time": timestamp })
	_update_text()

func _update_text():
	clear()
	for line in log_lines:
		add_text(line.text + "\n")
	scroll_to_line(get_line_count() - 1)

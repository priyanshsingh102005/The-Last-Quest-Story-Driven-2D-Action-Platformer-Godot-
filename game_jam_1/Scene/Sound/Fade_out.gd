extends AudioStreamPlayer

func fade_out(duration: float = 1.5):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, duration) # fade to silence
	tween.tween_callback(Callable(self, "stop")) # stop after fading

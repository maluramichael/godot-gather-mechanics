extends Spatial
class_name Building

signal food_is_ready

var getting_picked = false

func _on_Timer_timeout() -> void:
  food_ready()

func is_getting_picked():
  return getting_picked

func set_getting_picked(state):
  getting_picked = state

func food_ready():
  if is_getting_picked(): return
  $Particles.emitting = true
  emit_signal("food_is_ready", self)

func food_picked():
  $Particles.emitting = false
  set_getting_picked(false)

func get_gather_time():
  return 5.0

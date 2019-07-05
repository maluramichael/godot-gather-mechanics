extends Spatial

onready var workers: Spatial = $Workers

onready var resource_worker: Resource = load('res://worker.tscn')

const RAY_LENGTH = 1000

func _input(event: InputEvent) -> void:
  if event is InputEventMouseButton and event.is_pressed():
    var mouse_pos = get_viewport().get_mouse_position()
    var ray_from = $Camera.project_ray_origin(mouse_pos)
    var ray_to = ray_from + $Camera.project_ray_normal(mouse_pos) * RAY_LENGTH
    var space_state = get_world().direct_space_state
    var selection = space_state.intersect_ray(ray_from, ray_to)
    if selection and selection.collider == $Floor:
      var instance: Spatial = resource_worker.instance()
      instance.translate(selection.position)
      instance.connect("picked_food", self, "_on_Worker_picked_food")
      workers.add_child(instance)

func _on_Building_food_is_ready(building) -> void:
  find_nearest_worker(building)

func _on_Worker_picked_food(worker, building) -> void:
  print(worker, 'picked food', building)
  building.food_picked()
  worker.bring_resource_home($Castle)

func find_nearest_worker(building):
  var nearest_worker = null
  var distance = 99999
  for worker in workers.get_children():
    if worker.has_job():
      print(worker, 'already has a job')
      continue

    var direction:Vector3 = worker.translation - building.translation
    var distance_to_building = direction.length()
    if distance_to_building <= distance:
      distance = distance_to_building
      nearest_worker = worker

  if nearest_worker:
    nearest_worker.set_job(Worker.Action.Gather, building)
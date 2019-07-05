extends KinematicBody
class_name Worker

signal picked_food

enum Action {
  Gather,
  Gathering,
  StoreResource
}

class Job:
  func _init(action, destination):
    self.destination = destination
    self.action = action

  var destination: Spatial = null
  var action = null

var current_job: Job = null
var walkspeed: float = 10
var gather_timer: float = 0

func set_job(action, destination: Spatial):
  current_job = Job.new(action, destination)
  print(self, 'create new job', current_job)

func has_job():
  if current_job:
    return true
  else:
    return false

func bring_resource_home(destination: Spatial):
  current_job = Job.new(Action.StoreResource, destination)

func _physics_process(delta: float) -> void:
  if not has_job(): return

  match current_job.action:
    Action.Gather:
      look_at(current_job.destination.translation, Vector3.UP)
      var direction = current_job.destination.translation - translation
      var distance = direction.length()
      if distance < 2:
        current_job = Job.new(Action.Gathering, current_job.destination)
        current_job.destination.set_getting_picked(true)
        gather_timer = current_job.destination.get_gather_time()
      else:
        var targetVector = direction.normalized()
        move_and_collide(targetVector * walkspeed * delta)
    Action.Gathering:
      gather_timer = gather_timer - delta
      if gather_timer <= 0:
        gather_timer = 0
        emit_signal('picked_food', self, current_job.destination)
    Action.StoreResource:
      look_at(current_job.destination.translation, Vector3.UP)
      var direction = current_job.destination.translation - translation
      var distance = direction.length()
      if distance < 5:
        current_job = null
      else:
        var targetVector = direction.normalized()
        move_and_collide(targetVector * walkspeed * delta)
    _:
      pass
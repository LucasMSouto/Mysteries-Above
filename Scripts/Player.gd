extends CharacterBody3D

#Velocidades
const WALK = 5.0
const RUN = WALK * 2
const CROUCH = WALK * 0.60
const CRAWL = WALK * 0.30

#Velocidade atual
var SPEED = WALK

#Estado do player (o default é a andar)
var isCrouching = false
var isCrawling = false
var isRunning = false

#Força de salto
const JUMP_VELOCITY = 4.5 * 1.5

@export_subgroup("Fall Dmg")
#Variavel que guarda a velocidade anterior
var oldVelocity:float = 0.0
@export var fallDamageThreshold = 20

@onready var cameraArm := $SprintArmPivot

@onready var currentMesh = $MeshStanding
@onready var currentCollider = $StandingCollisionShape

func _physics_process(delta: float) -> void:
	#Handles Gravity...
	Gravity(delta)
	
	#Handles: Jump / LEFT / RIGHT / BACK / FOWARD / And the angle the player is facing
	PlayerInputs()
	
	#Changes The player pose (Standing - CRAWLING - CROUCH) - also handles speeds.
	PlayerColliderNMeshNSpeed()
	
	#Default do godot
	move_and_slide()
	
	#Handles: fall damage...
	fallDmg()
	
func setPlayerMeshLookRotation(angle):
	var rotationEuler = Basis.from_euler(Vector3(0, angle, 0))
	if currentMesh == $MeshCrawling:
		rotationEuler = Basis.from_euler(Vector3(deg_to_rad(90), angle, 0))
	currentCollider.basis = rotationEuler
	currentMesh.basis = rotationEuler
	

func Gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2.3

func PlayerInputs():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction = (cameraArm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		#Calculate direction if avaible
		#Now we calculate player facing rotation with the angle obtained from current rtoation and the direction the player should face
		var facingAngle = atan2(direction.x,direction.z) + PI
		setPlayerMeshLookRotation(facingAngle)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func PlayerColliderNMeshNSpeed():
	# Controlo da Velocidade do Jogador, Colider e Mesh
	if Input.is_action_just_pressed("crouch"):
		if isCrouching == false:
			movementStateChange("crouch")
			SPEED = CROUCH
		elif isCrouching == true:
			movementStateChange("uncrouch")
			SPEED = WALK
	elif Input.is_action_just_pressed("crawl"):
		if isCrawling == false:
			movementStateChange("crawl")
			SPEED = CRAWL
		elif isCrawling == true:
			movementStateChange("uncrawl")
			SPEED = WALK
	elif Input.is_action_just_pressed("run"):
		if  !isCrouching and !isCrawling:
			if isRunning == false:
				SPEED = RUN
				isRunning = true
			elif isRunning == true:
				SPEED = WALK
				isRunning = false

func movementStateChange(changeType):
	match changeType:
		"crouch":
			if isCrawling:
				$AnimationPlayer.play_backwards("CrouchToCrawl")
			else:
				$AnimationPlayer.play("StandingToCrouch")
			isCrouching = true

			changeCollisionShapeTo("crouching")
			isCrawling = false

		"uncrouch":
			$AnimationPlayer.play_backwards("StandingToCrouch")
			isCrouching = false
			isCrawling = false
			changeCollisionShapeTo("standing")

		"crawl":
			if isCrouching:
				$AnimationPlayer.play("CrouchToCrawl")
			else:
				$AnimationPlayer.play("StandingToCrawl")
			isCrouching = false
			isCrawling = true
			changeCollisionShapeTo("crawling")
 
		"uncrawl":
			$AnimationPlayer.play_backwards("StandingToCrawl")
			isCrawling = false
			isCrouching = false
			changeCollisionShapeTo("standing")

#Change collision shapes for standing, crouch, crawl
func changeCollisionShapeTo(shape):
	match shape:
		"crouching":
			#Disabled == false is enabled!
			$CrouchingCollisionShape.disabled = false
			$MeshCrounching.visible = true
			$CrawlingCollisionShape.disabled = true
			$MeshCrawling.visible = false
			$StandingCollisionShape.disabled = true
			$MeshStanding.visible = false
			currentMesh = $MeshCrounching
			currentCollider = $CrouchingCollisionShape
		"standing":
			#Disabled == false is enabled!
			$StandingCollisionShape.disabled = false
			$MeshCrounching.visible = false
			$CrawlingCollisionShape.disabled = true
			$MeshCrawling.visible = false
			$CrouchingCollisionShape.disabled = true
			$MeshStanding.visible = true
			currentMesh = $MeshStanding
			currentCollider = $StandingCollisionShape
		"crawling":
			#Disabled == false is enabled!
			$CrawlingCollisionShape.disabled = false
			$MeshCrounching.visible = false
			$StandingCollisionShape.disabled = true
			$MeshCrawling.visible = true
			$CrouchingCollisionShape.disabled = true
			$MeshStanding.visible = false
			currentMesh = $MeshCrawling
			currentCollider = $CrawlingCollisionShape

func fallDmg():
	if oldVelocity < 0: 
		var diff = velocity.y - oldVelocity
		if diff > fallDamageThreshold:
			hurt()
	oldVelocity = velocity.y

func hurt():
	print_debug("Ouch!!")
	pass

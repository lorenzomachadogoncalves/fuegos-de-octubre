extends Node2D

@export var cor_portal: Color = Color(0.5, 0.0, 1.0)
@export_range(0.0, 1.0) var opacidade: float = 0.55
@export var next_scene: String
@export var target_door_name: String

func _ready() -> void:
	_aplicar_cor()

func _aplicar_cor() -> void:
	var interior := $PortalInterior as Sprite2D
	if interior and interior.material:
		var mat := interior.material.duplicate() as ShaderMaterial
		interior.material = mat
		mat.set_shader_parameter("cor", cor_portal)
		mat.set_shader_parameter("opacidade", opacidade)

	var particulas := $PortalParticles as GPUParticles2D
	if particulas and particulas.process_material:
		var mat := particulas.process_material as ParticleProcessMaterial
		mat.color = cor_portal

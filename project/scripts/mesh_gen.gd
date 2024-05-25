class_name MeshGen
extends RefCounted

const bullet_material := preload("res://materials/bullet.tres")

enum Kind {
	SPHERE,
	POINTY,
}

# Hitbox radius
const SCALE := 0.1

func get_meshes() -> Dictionary:
	var meshes := {}
	for fn in get_method_list():
		if fn.name.match("_gen_*"):
			call(fn.name, meshes)
	return meshes

func _gen_sphere(meshes: Dictionary) -> void:
	var mesh := SphereMesh.new()
	mesh.radius = SCALE
	mesh.height = 2.0 * SCALE
	mesh.surface_set_material(0, bullet_material)
	meshes[Kind.SPHERE] = mesh

func _gen_pointy(meshes: Dictionary) -> void:
	var st := SurfaceTool.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	st.add_vertex(Vector3.FORWARD * SCALE)
	st.add_vertex(Vector3.UP * SCALE)
	st.add_vertex(Vector3.LEFT * SCALE)
	st.add_vertex(Vector3.DOWN * SCALE)
	st.add_vertex(Vector3.RIGHT * SCALE)
	st.add_vertex(Vector3.BACK * 3.0 * SCALE)

	st.add_index(0)
	st.add_index(1)
	st.add_index(2)

	st.add_index(0)
	st.add_index(2)
	st.add_index(3)

	st.add_index(0)
	st.add_index(3)
	st.add_index(4)

	st.add_index(0)
	st.add_index(4)
	st.add_index(1)

	st.add_index(5)
	st.add_index(1)
	st.add_index(4)

	st.add_index(5)
	st.add_index(4)
	st.add_index(3)

	st.add_index(5)
	st.add_index(3)
	st.add_index(2)

	st.add_index(5)
	st.add_index(2)
	st.add_index(1)

	st.generate_normals()

	var mesh := st.commit()
	mesh.surface_set_material(0, bullet_material)
	meshes[Kind.POINTY] = mesh

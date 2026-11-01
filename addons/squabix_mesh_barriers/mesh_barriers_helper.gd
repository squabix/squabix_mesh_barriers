class_name MeshBarriersHelper
extends Object

const VECTOR3X := Vector3i(1, 0, 0)
const VECTOR3Y := Vector3i(0, 1, 0)
const VECTOR3Z := Vector3i(0, 0, 1)
static var nodestr_root: Node


static func node_error(error: String, ...injections: Array) -> void:
	for i in len(injections):
		var element: Variant = injections[i]
		if not is_instance_valid(element) or not element is Node:
			continue
		injections[i] = nodestr(element)
	push_error(error % injections)


static func get_tree() -> SceneTree:
	var main_loop := Engine.get_main_loop()
	if main_loop == null:
		push_error("Cannot get tree root without main loop")
		return null
	return main_loop as SceneTree


static func nodestr(node: Node) -> String:
	if not is_instance_valid(node) or not is_instance_valid(node.get_tree().root):
		return "Invalid Node (%s)" % node

	var root: Node
	if not is_instance_valid(nodestr_root):
		if not is_instance_valid(node.get_tree().root):
			node_error("Cannot find root for %s", node)
			return "Invalid Node (%s)" % node
		root = node.get_tree().root
	elif nodestr_root.get_path_to(node).is_empty():
		node_error("Cannot find root for %s", node)
		return "Invalid Node (%s)" % node
	else:
		root = nodestr_root

	return "%s (%s)" % [node.name, root.get_path_to(node)]


static func vec3to2(v: Vector3, axis: Vector3i) -> Vector2:
	match axis:
		VECTOR3X:
			return Vector2(v.y, v.z)
		VECTOR3Y:
			return Vector2(v.x, v.z)
		VECTOR3Z:
			return Vector2(v.x, v.y)
	return Vector2.ZERO


static func vec2to3(v: Vector2, axis: Vector3i) -> Vector3:
	match axis:
		VECTOR3X:
			return Vector3(0.0, v.x, v.y)
		VECTOR3Y:
			return Vector3(v.x, 0.0, v.y)
		VECTOR3Z:
			return Vector3(v.x, v.y, 0.0)
	return Vector3.ZERO

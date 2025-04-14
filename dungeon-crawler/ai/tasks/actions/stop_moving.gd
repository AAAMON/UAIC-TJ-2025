@tool
extends BTAction

func _generate_name() -> String: return "stop moving"

func _tick(_delta: float) -> Status:
	agent.nav_agent.velocity = Vector3.ZERO
	return SUCCESS

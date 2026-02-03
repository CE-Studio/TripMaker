extends PanelContainer


func _on_yes() -> void:
	EditorBeat.instance.reset_all()
	_on_no()


func _on_no() -> void:
	Statics.editor_accepts_inputs = true
	queue_free()

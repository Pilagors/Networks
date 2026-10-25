extends Node
class_name ObjectCollection

var liste : Array[ConnectedObject]
var max_size : int

func _init(size: int) -> void:
	self.liste = []
	self.liste.resize(size)
	self.max_size = size

## ajoute l'objet dans la première place disponible de la liste
func add_object(object: ConnectedObject) -> void:
	if object == null:
		return
	
	for i in range(liste.size()):
		if self.liste[i] == null:
			self.liste[i] = object
			break

## retourne [code]true[/code] si l'objet est présent, [code]false[/code] sinon
func contains_object(object: ConnectedObject) -> bool:
	if object == null:
		return false

	return self.liste.find(object) != -1

## remplace l'objet par [code]null[/code]
func remove_object(object: ConnectedObject) -> void:
	var index = self.liste.find(object)
	
	if index == -1:
		return
	
	self.liste[index] = null

## récupère l'objet à l'index renseigné
func get_object(index: int) -> ConnectedObject:
	if index >= 0 && index < self.liste.size():
		return self.liste[index]
	return null

## vide la liste de ses éléments
func empty_list() -> void:
	self.liste.fill(null)

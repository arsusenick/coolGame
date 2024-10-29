extends Node
class_name State

#NOTE This is the State base-class, all states inherits this logic

@export var character: CharacterBody2D
@export var animationPlayer: AnimationPlayer

signal transitioned

func enter():
	pass

func exit():
	pass

func update(_delta:float):
	pass
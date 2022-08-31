extends Control


var spots = []
var textToDraw = {}

var font


func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://GFX/Peach Days.ttf")
	font.size = 30


func _draw():
	print(spots)
	for i in spots:
		draw_circle(i, 10, Color(0,0,1,.2))
	for i in textToDraw:
		draw_string(font, textToDraw[i], str(i), Color(1.0, 0.0, 0.0, .5)); 


func _on_Button_pressed():
	print("CLICK")
	get_node("../"+$controltarget.text).move_to(int($from.text), int($to.text))

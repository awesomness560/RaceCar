extends Label
 
var time : float
 
func _physics_process(delta):
	time += delta
	update_ui()
	
func update_ui():
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed : String
	
	if mils == 0:
		time_passed = "%02d : %02d : 00" % [mins,secs]
	else:
		time_passed = "%02d : %02d : %02d" % [mins,secs,mils]
	
	if mins < 1:
		time_passed = time_passed.right(-4)
	
	text = time_passed

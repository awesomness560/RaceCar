extends ProgressBar
class_name NitroBar

@export var timeToTween : float = 0.2 ##The time it takes for the progress bar to reach the real value
@export_group("References")
@export var feedbackBar : ProgressBar
@export var timer : Timer

var nitro = 0 : set = setNitro

var feedbackBarTween : Tween
var nitroBarTween : Tween

func _ready():
	timer.timeout.connect(onTimerTimeout)

func setNitro(newNitro):
	var prevNitro = nitro
	nitro = min(max_value, newNitro)
	tweenNitro(nitro)
	
	if nitro < prevNitro:
		timer.start()
	else:
		tweenDamage(nitro)

func initNitro(_nitro): ##Call when using the nitro bar so that the nitro bar can be set up correctly
	nitro = _nitro
	max_value = nitro
	value = nitro
	
	feedbackBar.max_value = nitro
	feedbackBar.value = nitro

func onTimerTimeout():
	tweenDamage(nitro)

func tweenNitro(_nitro):
	if nitroBarTween:
		nitroBarTween.kill()
		
	nitroBarTween = create_tween()
	nitroBarTween.tween_property(self, "value", _nitro, timeToTween)

func tweenDamage(_nitro):
	if feedbackBarTween:
		feedbackBarTween.kill()
	
	feedbackBarTween = create_tween()
	feedbackBarTween.tween_property(feedbackBar, "value", _nitro, timeToTween)

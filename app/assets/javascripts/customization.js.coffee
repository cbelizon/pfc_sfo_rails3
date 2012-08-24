$ ->
	$(document).button()
	$(document).alert()
	return false
#Autoreload match
$ ->
	exist = $(".in-play").length > 0
	if exist
		setInterval("location.reload(true)", 60000);




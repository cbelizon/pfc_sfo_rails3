$ ->
	$(document).button()
	$(document).alert()
	return false
#Autoreload match
$ ->
	exist = $(".in-play").html()
	if exist != null
		setInterval("location.reload(true)", 60000);




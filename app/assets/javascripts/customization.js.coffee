$ ->
	$(document).button()
	$(document).alert()
	return false
#Autoreload match
$ ->
	exist = $(".in-play").length > 0
	if exist
		count = 60
		$(".countdown .seconds").html(count)
		count--
		countdown = setInterval ->
			$(".countdown .seconds").html(count)
			if count == 0
				location.reload(true)
			count--
		, 1000
#Manual reload
$ ->
	clickable = $(".in-play img, .in-play .countdown").click ->
		location.reload(true)





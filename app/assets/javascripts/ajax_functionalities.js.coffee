#pagination ajax requests with table container
$ ->
	$('.pagination-container .pagination-pages a').live 'click', ->
		if $(this).parents('.pagination-container ul').hasClass('disabled') || $(this).parent('li').hasClass('.active')
			false
		else
			$(this).parents('.pagination-container ul').addClass('disabled')
			$(this).parents('.pagination-container ul').find('li').addClass('disabled')
			params = this.href
			table_container = $(this).parents('.pagination-container').find('.table-content')
			height = table_container.height()
			table_container.fadeOut 'fast', ->
				$(this).html('<div class="ajax-loader"></div>')
				$(this).children('.ajax-loader').height(height)
				$(this).fadeIn 'fast', ->
					$.get params, null, null, 'script'
			false
#search ajax request with table container
$ ->
	$('.pagination-container form').live 'submit', ->
		action = $(this).attr('action')
		params = $(this).serialize()
		table_container = $(this).parents('.pagination-container').find('.table-content')
		height = table_container.height()
		table_container.fadeOut 'fast', ->
			$(this).html('<div class="ajax-loader"></div>')
			$(this).children('.ajax-loader').height(height)
			$(this).fadeIn 'fast', ->
				$.get(action, params, null, 'script')
		return false

#substitution ajax
$ ->
	$('.team .team-open .substitution').hide()
	$('.team .team-open input[type="submit"]').hide()
	$('.team .team-open .substitution').attr('checked', false)
	substitution1 = null
	substitution2 = null
	$('.team .team-open tr').live 'click', ->
		clicked = $(this).attr('id')
		#none clicked
		if !substitution1 && !substitution2
			substitution1 = clicked
			$(this).find('.substitution-player1').attr('checked', true)
			$(this).find('td').addClass('selected')
			return false
		#second distinct than first clicked serialize and send
		if substitution1 && !substitution2 && clicked != substitution1
			substitution2 = clicked
			$(this).find('.substitution-player2').attr('checked', true)
			$(this).find('td').addClass('selected')
			$(".selected").fadeOut(1000, 0).fadeIn 1000, ->
				action = $(this).parents('form').attr('action')
				params = $(this).parents('form').serialize()
				$.post action, params, ->
					$('.team .team-open .substitution').hide()
					$('.team .team-open .substitution').attr('checked', false)
					$('.team .team-open input[type="submit"]').hide()
					substitution1 = null
					substitution2 = null
				, 'script'
				return false
		#click on same twice cancel action
		if substitution1 && !substitution2 && clicked == substitution1
			substitution1 = null
			$(this).find('.substitution-player1').attr('checked', false)
			$(this).find('td').removeClass('selected')
			return false


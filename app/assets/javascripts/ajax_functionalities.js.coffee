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

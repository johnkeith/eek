$ ->
	$(".notice, .alert").delay(2000).fadeOut("slow")
	$(".notice, .alert").on("click", (event)->
		$(event.target).parents('div:first').hide("slow")
	)
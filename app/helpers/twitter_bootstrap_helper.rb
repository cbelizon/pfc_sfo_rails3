module TwitterBootstrapHelper
	def will_paginate_rows_per_page(path, options = {})
		html_class ||= options[:class]
		rows ||= options[:rows]
		param ||= options[:param]
		title ||= options[:title]

		bootstrap_button_dropdown(:html_options => {:class => 'pull-right'}) do |b|
			b.bootstrap_button title, "#", :type => html_class
			rows.each do |row|
				b.link_to(row, params.merge({param => row}))
			end
		end
	end
end

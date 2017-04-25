module ApplicationHelper
	def Full_title(page_title)
		base_title="Ruby on Rails tutorial App"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}" 
		end
	end
end

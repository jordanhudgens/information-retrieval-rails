module ApplicationHelper
	def convert_tags_to_links(tags: tags)
		arr = convert_tags_to_array(tags)
		link_string = ""
		arr.map { |e| link_string << "<a href='questions?utf8=✓&q=#{e}'>#{e}</a>&nbsp;/&nbsp;" }
		link_string.html_safe
	end

	def convert_tags_to_array(str)
		str.gsub!(/(\,)(\S)/, "\\1 \\2")
		YAML::load(str)
	end
end

class Question < ActiveRecord::Base
	searchkick text_start: [:title], suggest: [:title]

  def search_data
    {
      title: title,
      tags: tags
    }
  end
end
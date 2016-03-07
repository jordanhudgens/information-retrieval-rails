class Question < ActiveRecord::Base
	searchkick  text_start: [:title], suggest: [:title],highlight: [:title], synonyms: [["software engineer", "software developer"], ["operating system", "OS"], ["HTML", "hypertext markup language"],["machine language","machine code"],["XML","Extensible Markup Language"]], wordnet: true
  def search_data
    {
      title: title,
      tags: tags
    }
  end
end
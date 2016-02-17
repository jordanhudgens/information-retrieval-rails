class ApiQuery
  def initialize
  	@api_root = "http://api.stackexchange.com"
  	@answers = HTTParty.get(@api_root + '/2.2/answers?site=stackoverflow')
  end

  def output_answers
    @answers.to_dish.items
  end

  def question_generator(question_id)
    question_data = get_specific_question_in_json(question_id).to_dish.items
    question_data.each do |question|
      add_question_to_database(
        tags: question.tags,
        link: question.link,
        creation_date: question.creation_date,
        title: question.title,
        question_id: question.question_id
      )
    end
  end

  def add_answer_to_database(reputation, user_id, profile_image, display_name, profile_link, answer_id, question_id)
    return if Answer.find_by(question_id: question_id)
    Answer.create!(
      reputation: reputation,
      user_id: user_id,
      profile_image: profile_image,
      display_name: display_name,
      profile_link: profile_link,
      answer_id: answer_id,
      question_id: question_id
    )
  end

  def get_specific_question_in_json(question_id)
    HTTParty.get(@api_root + "/2.2/questions/#{question_id}?order=desc&sort=activity&site=stackoverflow")
  end

  def add_question_to_database(tags: tags, link: link, creation_date: creation_date, title: title, question_id: question_id)
    return if Question.find_by(question_id: question_id)
    Question.create!(
      tags: tags,
      link: link,
      creation_date: creation_date,
      title: title,
      question_id: question_id
    )
  end

  def generator
    output_answers.each do |answer|
      add_answer_to_database(answer.owner.reputation, answer.owner.user_id, answer.owner.profile_image, answer.owner.display_name, answer.owner.link, answer.question_id, answer.answer_id)
      question_generator(answer.question_id)
    end
  end
end
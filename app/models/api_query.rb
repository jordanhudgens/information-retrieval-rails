class ApiQuery
  def initialize
  	@api_root = "http://api.stackexchange.com"
  	@answers = HTTParty.get(@api_root + '/2.2/answers?site=stackoverflow').body
  end

  def get_specific_question_in_json(question_id)
  	@api_root + "/2.2/#{question_id}/25576088?order=desc&sort=activity&site=stackoverflow"
  end

  def parse_json
  end

  # pseudo code for data acquisition algorithm

  # Contact the stackexchange API via scheduled, background job

  # Get the past day's list of answers

  # Query the local db to see if the question ID exists

  # If the question ID does not exist it calls the `get_specific_question_in_json`

  # It then creates a new entry for that question in the db

  # There is a relational connection between question and answers

  # The goal of having answers queried is this:

  ## It will give better historical question results

  ## They can be used to gauge popularity

  ## If we only queried the question API we'd only get new questions and miss out on historical questions (arguably the more important questions)
end
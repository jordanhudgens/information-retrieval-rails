class QuestionsController < ApplicationController
	def index
		query = params[:q].presence || "*" 
		@questions = Question.search(query, suggest: true,order: {_score: :desc},fields: [{title: :text_start}], highlight: {tag: "<strong>", fields: {description: {fragment_size: 100}}},page: params[:page], per_page: 20)
		@questions = 	@questions.first
        @questions.similar(fields: ["title"])
	end

  def autocomplete
    render json: Question.search(params[:term], fields: [{title: :text_start}], limit: 10).map(&:title)
  end
end
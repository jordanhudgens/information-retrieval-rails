class QuestionsController < ApplicationController
	def index
		query = params[:q].presence || "*" 
		@questions = Question.search(query, suggest: true,order: {_score: :desc},page: params[:page], per_page: 20)
		
		if current_user && query
			return if query == '*'
			History.create!(user_id: current_user.id, query_title: query)
		end
	end

  def autocomplete
    render json: Question.search(params[:term], fields: [{title: :text_start}], limit: 10).map(&:title)
  end
end
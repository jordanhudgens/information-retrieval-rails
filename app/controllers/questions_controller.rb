class QuestionsController < ApplicationController
	def index
		query = params[:q].presence || "*"
		@questions = Question.search(query, suggest: true, page: params[:page], per_page: 20)
	end

  def autocomplete
    render json: Question.search(params[:term], fields: [{title: :text_start}], limit: 10).map(&:title)
  end
end
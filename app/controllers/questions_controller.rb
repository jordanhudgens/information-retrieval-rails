class QuestionsController < ApplicationController
	def index

		query = params[:q].presence || "*" 
		
		if :sort_option == 2
      sort = "desc"
    else
    	sort = "asc"
    end
    
    case :per_page
    when 20
    	page = 20
    when 50
    	page = 50
    when 100
    	page = 100
    end

		@questions = Question.search(query, suggest: true,order: {_score: :desc},page: params[:page], per_page: page)

		if current_user && query && current_user.histories
			return if query == '*'
			@questions = Question.search(query, suggest: true,order: {_score: sort},page: params[:page], per_page: page)
			History.create!(user_id: current_user.id, query_title: query)
		end
	end

  def autocomplete
    render json: Question.search(params[:term], fields: [{title: :text_start}], limit: 10).map(&:title)
  end

  def history
  	authenticate_user!
  	@past_searches = current_user.histories.order(created_at: :desc).page(params[:page]).per(5)
  end
end
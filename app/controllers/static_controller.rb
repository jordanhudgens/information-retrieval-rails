class StaticController < ApplicationController
	def homepage
		@results = Question.page(params[:page]).per(15)
	end
end
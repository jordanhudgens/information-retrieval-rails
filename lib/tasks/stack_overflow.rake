namespace :stack_overflow do
  desc "Calls the StackOverflow API and creates local db records"
  task generator: :environment do
  	a = ApiQuery.new
  	a.generator
  end
end

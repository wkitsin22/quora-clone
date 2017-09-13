# enable :sessions

get '/' do
	# session[:user_id] = nil 
	# session[:user_id] = nil 
	if current_user == nil 
		erb :"static/index"
	else 
  		redirect '/home'
  	end 
end

post '/create_user' do 
	user = User.new(name: params[:name], email: params[:email], password: params[:password], 
		password_confirmation: params[:confirmation_password])

	if user.save 
		session[:user_id]= user[:id]
		redirect "/home"
	else 
		@error = "Asdsa"
		erb :"static/index"
	end 
end 

get '/home' do
	@question = Question.paginate(page: params[:page], per_page: 2)
	# @user_id = Question.find(@question.user_id).name 
	# byebug
	if current_user == nil 
		redirect "/"
	else 
		erb :"static/home"
	end 
end 

post "/login" do 
	# puts params
	# user = User.find_by(email: params[:email])
	# puts "++++++++++++++++++++++++++"
	# user.authenticate(params[:password])
	login = User.find_by(email: params[:email]).try(:authenticate, params[:password]) 
	# byebug
	if login == nil 
		@error1 = 'asdasda'
		erb :"static/index"
	else  
		session[:user_id]= login[:id]
		# byebug
		redirect "/home"
	end 
end 

post "/logout" do 
	session[:user_id] = nil 
	redirect "/"
end 

get "/user/:id" do 
	# byebug/
	puts "+++++++++++++++++++++"
	puts params 
	if current_user == nil 
		redirect "/"
	else 
		@user = User.find_by(id: params[:id]).name
		erb :"users/profile"
	end 
end 

post "/question" do 

	question = Question.new(question: params[:question], user_id: current_user.id)

	# byebug
	if question.save 
		# question.to_json
		votes = Questionvote.total_vote(question.id)
		{vote_count: votes, user: question.user_id, message: question.question, person: User.find_by(id: question.user_id).name, id: question.id}.to_json
	else 
		erb :"static/home"
	end 
end 

post "/answer" do 
	puts "+++++++++++"
	puts params 
	# byebug
	answer = Answer.new(answer: params[:answer], user_id: current_user.id, question_id: params[:question_id])
	# puts answer
	# byebug
	if answer.save 
		# answer.to_json
		votes = Answervote.total_vote(answer.id)
		{vote_count: votes, answer_id: answer.id, user: answer.user_id, message: answer.answer, person: User.find_by(id: answer.user_id).name}.to_json
	else 
		erb :"static/home"
	end 
end 

get "/myquestions" do 
	@a=User.find(current_user.id) 
	@b=@a.questions 
	@username = User.find_by(id: session[:user_id]).name
	if current_user == nil 
		redirect "/"
	else 
		erb :"static/questions"
	end 
end 

get "/one_question/:id" do 
	@questionid = params[:id]
	@a=Question.find(@questionid).question 
	@b=Question.find(@questionid).user_id 
	@c=User.find_by(id: Question.find(@questionid).user_id).name  
	@d=Question.find(@questionid).id 
	erb :"static/one_question"
end 

get "/myanswers" do
	@a=current_user.id
	@b=User.find(@a) 
	@c=@b.answers 
	@z=[] 

	@c.each do |i| 
		@z << i.question_id 
	end 
	# @v = Question.where(id: @z)
	@question_user = User.find(@a).questions
	@answer_user = User.find(@a).answers
	byebug

	erb :"static/answers"
end 

post "/questionvote" do
	puts "+++++++++++++++++++++++++"
	puts params 
	# byebug
	if params[:vote] == '1'
		convert = true 
	else 
		convert = false 
	end 


	questionid = params[:question_id]
	# find whether user voted before or not 

	user_vote = Questionvote.find_by(user_id: current_user.id, question_id: questionid) #this returns the object 
	puts user_vote
	# byebug
	if user_vote == nil 
		vote = Questionvote.new(user_id: current_user.id, question_id: params[:question_id], votes: params[:vote])

		if vote.save 
			# redirect "/"
			# byebug
			{vote: vote, count: Questionvote.total_vote(params[:question_id])}.to_json
		else 
			@error2 = 'Error'
		end 
	else 
		# find for the same question 
		# and also find for the user
		# user = Questionvote.where(user_id: current_user.id).user_id
		type_of_vote = user_vote.votes
		puts type_of_vote
		puts convert 
		# byebug 

		if type_of_vote == convert
			Questionvote.delete(user_vote.id)
		elsif 
			Questionvote.update(user_vote.id, :votes => convert)
		end 
		# byebug
		# redirect "/"
		{vote: user_vote, count: Questionvote.total_vote(params[:question_id])}.to_json


	end 
end 

post "/answervote" do 

	puts "+++++++++++++++++++++++++"
	puts params 
	# byebug
	if params[:vote] == '1'
		convert = true 
	else 
		convert = false 
	end 

	questionid = params[:question_id]
	answerid = params[:answer_id]
	# find whether user voted before or not 

	user_vote = Answervote.find_by(answer_id: answerid) #this returns the object 
	puts "+++++++++++++++++++++++++++++"
	puts user_vote
	# byebug
	if user_vote == nil 
		vote = Answervote.new(answer_id: answerid ,user_id: current_user.id, question_id: params[:question_id], votes: params[:vote])

		if vote.save 
			# redirect "/"
			# byebug
			{vote: vote, count: Answervote.total_vote(params[:answer_id])}.to_json
		else 
			@error3 = 'Error'
		end 
	else 
		# find for the same question 
		# and also find for the user
		# user = Questionvote.where(user_id: current_user.id).user_id
		type_of_vote = user_vote.votes
		puts type_of_vote
		puts convert 
		# byebug 

		if type_of_vote == convert
			Answervote.delete(user_vote.id)
		elsif 
			Answervote.update(user_vote.id, :votes => convert)
		end 
		# byebug
		# redirect "/"
		{vote: user_vote, count: Answervote.total_vote(params[:answer_id])}.to_json


	end 

end 
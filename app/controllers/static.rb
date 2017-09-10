# enable :sessions

get '/' do
	# session[:user_id] = nil 
	# session[:user_id] = nil 
	if current_user == nil 
		erb :"static/index"
	else 
  		erb :"static/home"
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
	puts "+++++++++++++++++++"
	puts params 
	# byebug
	question = Question.new(question: params[:question], user_id: current_user.id)
	# byebug
	if question.save 
		# question.to_json
		{message: question.question, person: User.find_by(id: question.user_id).name, id: question.id}.to_json
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
		{message: answer.answer, person: User.find_by(id: answer.user_id).name}.to_json
	else 
		erb :"static/home"
	end 
end 

get "/myquestions" do 
	if current_user == nil 
		redirect "/"
	else 
		erb :"static/questions"
	end 
end 

get "/one_question/:id" do 
	@questionid = params[:id]
	erb :"static/one_question"
end 

get "/myanswers" do
	erb :"static/answers"
end 
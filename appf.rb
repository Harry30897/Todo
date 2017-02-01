require 'sinatra'
require 'data_mapper'

set :sessions ,true

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/data.db")


class User
	include DataMapper::Resource
	property :email, String
	property :password, String
	property :id, Serial
end	

class Task
    include DataMapper::Resource
    property :id, Serial
    property :content, String
    property :completed, Boolean
    property :type_u, Boolean
    property :type_i, Boolean
    property :user_id, Integer
end

DataMapper.finalize
User.auto_upgrade!
Task.auto_upgrade!

get '/' do
	erb :signin
end


get '/signup' do
	erb :signup
end


post '/signup' do
	email = params[:email]
	password = params[:password]
    user = User.all(:email=>email).first
    if user
    	redirect '/signup'
    else
    	user = User.new
    	user.email = params[:email]
    	user.password = params[:password]
    	user.save
    	session[:user_id] = user.id
    	redirect '/temp'
    end	
end


post '/signin' do
	email = params[:email]
	password = params[:password]
	user = User.all(:email=> email).first

	if user
		if user.password == password
			session[:user_id] = user.id
			redirect '/temp'
		else 
			redirect '/'
		end
	else
		redirect '/signup'
	end	
	redirect '/temp'
end
			

get '/temp' do
	user_id = session[:user_id]
	tasks = Task.all(:user_id=>user_id)
    erb :tasks, locals: {:tasks => tasks}
end	


post '/signout' do
	session[:user_id] = nil
	redirect '/'
end	



post '/add_task' do
	task = Task.new
    task.content = params[:task]
    task.user_id = session[:user_id]
    task.completed = false
    task.save
    redirect '/temp'
end	

post '/toggle_task' do	
	task_id = params[:task_id]
    task = Task.get(task_id)
    if task.user_id == session[:user_id]
		task.completed = !task.completed
		task.save
	end
    redirect '/temp'
end

post '/typei' do
	task_id = params[:task_id]
    task = Task.get(task_id)
    if task.user_id == session[:user_id]
     	task.type_i = !task.type_i
     	task.save
    end
	redirect '/temp'
end		


post '/typeu' do
	task_id = params[:task_id]
    task = Task.get(task_id)
    if task.user_id == session[:user_id]
     	task.type_u = !task.type_u
     	task.save
    end
    redirect '/temp'
end		

delete '/delete' do
	task_id = params[:task_id]
    task = Task.get(task_id)
    if task.user_id == session[:user_id]
    	task.destroy
    end	
	redirect '/temp'
end		


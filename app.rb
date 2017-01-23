require 'sinatra'

class Task
	attr_reader :task, :id, :completed, :type_i, :type_u
	def initialize task, id
		@task = task
		@id = id
		@completed=false
		@type_i=false
		@type_u=false
	end
	def toggle_task
		@completed = !@completed
	end	
    def to_s
		"Task: #{@task}, Completed: #{@completed}"
	end

	def typei
		@type_i=!@type_i
	end	
	def typeu
		@type_u=!@type_u
	end	
end		

tasks = []
unid = 0

get '/' do
	#puts tasks
	erb:tasks, locals: {:tasks =>tasks, :time=> Time.now}
end
post '/add_task' do
	unid = unid + 1
	puts unid
	task = Task.new params[:task], unid
	puts task
	tasks << task
	redirect '/'
end	

post '/toggle_task' do
	task_id = params[:task_id]
	task_object = nil
	tasks.each do |task|
		if task.id == task_id.to_i
			task_object = task
			break
		end
	end
	if task_object
			task_object.toggle_task
			if task_object.type_i
				task_object.typei
			end
			if task_object.type_u
				task_object.typeu
			end	
	end
	redirect '/'
end

post '/typei' do
	task_id= params[:task_id]
	task_object=nil
	tasks.each do |task|
		if task.id == task_id.to_i
			task_object = task
			break
		end
	end	
	if task_object
		task_object.typei
	end
	redirect '/'
end		


post '/typeu' do
	task_id= params[:task_id]
	task_object=nil
	tasks.each do |task|
		if task.id == task_id.to_i
			task_object = task
			break
		end
	end	
	if task_object
		task_object.typeu
	end
	redirect '/'
end		

post '/delete' do
	task_id= params[:task_id]
	task_object=nil
	tasks.each do |task|
		if task.id == task_id.to_i
			task_object = task
			break
		end
	end	
	if task_object
		tasks.delete(task_object)
	end
	redirect '/'
end		


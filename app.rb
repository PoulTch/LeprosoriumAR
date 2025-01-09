#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "leprosorium.db"}

class Post < ActiveRecord::Base
	validates :author, presence: true
	validates :content, presence: true	
end

class Comment < ActiveRecord::Base
	validates :content, presence: true
end
		

before do 
	@p = Post.all
	@comments = Comment.all
end
	
	
get '/' do
	# выбираем список постов из БД

		@posts = Post.order('created_at DESC')

	erb :index			
end

# обработчик get-запроса /new
# (браузер) получает страницу с сервера

get '/new' do
		@p = Post.new		
	  erb :new
end

# обработчик post-запроса /new
# (браузер отправляет данные на сервер)

post '/new' do
                                                             
  # сохранение данных в БД

	@p = Post.new params[:post]
	if @p.save
		redirect to '/'
	  else
    @error = @p.errors.full_messages.first
    return erb :new
  end

end
  

    



#get '/details/:post_id' do
get '/details/:post_id' do

	@c = Comment.new	

	# получаем парамер, id поста, из URL
	
	post_id = params[:post_id]

	# получаем список постов (у нас будет только один пост)
	#results = @db.execute 'select * from Posts where id = ?', [post_id]
	results = Post.find(post_id)

	# выбираем этот один пост в переменную @row
	@row = results

	# выбираем комментарии для нашего поста
	#@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]
	@comments = Comment.where(post_id: post_id).order('created_at DESC')
	


	# возвращаем представление details.erb
	erb :details
end



# обработчик post-запроса /details/...
# (браузер отправляет данные на сервер, мы их принимаем)

post '/details/:post_id' do	

	# получаем парамер, id поста, из URL
	post_id = params[:post_id]

	content = params[:comment]	

  @c = Comment.new params[:comment]
  #@c.content = content  - получается некрасивый вывод: {"content"=>"Пятый комментарий"}
  @c.post_id = post_id
	if @c.save		
		redirect to('/details/' + post_id)		
	else
    @error = @c.errors.full_messages.first
 	#return erb :new
 	redirect to('/details/' + post_id)   
	end

end
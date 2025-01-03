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
		

before do 
	@p = Post.new
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
	      else
      	@error = @p.errors.full_messages.first
      erb :new
  end
	                                                                                            
  erb :new
end
  

    



get '/details/:post_id' do

	# получаем парамер, id поста, из URL
	post_id = params[:post_id]

	# получаем список постов (у нас будет только один пост)
	results = @db.execute 'select * from Posts where id = ?', [post_id]

	# выбираем этот один пост в переменную @row
	@row = results[0]

	# выбираем комментарии для нашего поста
	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	# возвращаем представление details.erb
	erb :details
end

# обработчик post-запроса /details/...
# (браузер отправляет данные на сервер, мы их принимаем)

post '/details/:post_id' do

	# получаем парамер, id поста, из URL
	post_id = params[:post_id]

	# получает переменную из post-запроса
  content = params[:content]

  if content.length <= 0
  	@error = 'Type comment text'
  	return erb :new
  end

    # сохранение данных в БД

  @db.execute 'insert into Comments 
  (
  		content,
  		created_date,
  		post_id
  ) 
  		values
  (
  		?, 
  		datetime(),
  		?
  )', [content, post_id]

  # перенаправляем на страницу поста

  redirect to('/details/' + post_id)

end
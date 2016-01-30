#require 'bundler'
#Bundler.require

class WLMS < Sinatra::Base
include BCrypt

#DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/main.db')
#require './models.rb'
configure do
  set :erb, :layout => :'layouts'
end
#------------------SESSION--------------------
use Rack::Session::Cookie, :key => 'rack.session',
    :expire_after => 2592000,
    :secret => SecureRandom.hex(64)
#---------GET ROUTES---------------
get '/' do
  @signup = ENV["Signup"]
  @user = User.first(:id => session[:id])
  erb :landing
end
get '/dashboard' do
  if session[:visited]
    puts Time.new

    @posts = Post.where(:type => "update")
    @posts=@posts.reverse_order(:id)
    puts @posts.inspect
    @user = User.first(:id => session[:id])
    erb :dash
  else
    redirect not_found
  end
end
get '/blog' do
  @posts = Post.where(:type => "blog")
  if session[:visited]
    @posts.where(:draft => 0)
    @user = User.first(:id => session[:id])
  end
  @posts = @posts.reverse_order
  erb :blog
end
  get '/blog/new' do
    @user = User.first(:id => session[:id])
    @user.perm == 3 ? @publishC = true :  @publishC = false
    @isEdit = false # I use the same view for both creating and editing the blog, but there need to be slightly different controls
    erb :blogMake
  end
  get '/blog/edit/:id' do
    @blog = Post.first(:id => params[:id])
    @user = User.first(:id => session[:id])
    @user.perm == 3 ? @publishC = true :  @publishC = false
    @isEdit = true # I use the same view for both creating and editing the blog, but there need to be slightly different controls
    erb :blogMake
  end
get '/settings' do
  if session[:visited]
    puts @test
    @user = User.first(:id => session[:id])
    erb :settings
  else
    redirect not_found
  end
end
get '/logout' do
  session.clear
  redirect '/'
end
not_found do
  @user=User.first(:id => session[:id])
  erb :notfound
end
  get '/oculus' do
    erb :oculus
  end
#-------------POST ROUTES---------------------
post '/user/auth' do

  @u = User.first(:email => params[:email])
  puts @u
  puts Password.new(@u.password)
  puts @u.password
  puts params[:password]
  puts Password.create(@u.password)
  puts Password.create(params[:password])
  if @u && Password.new(@u.password) == params[:password]
    session[:id] = @u.id
    session[:visited] = true
    redirect '/dashboard'
  else
    redirect '/'
  end
end
post '/user/create' do
  u = User.new
  u.firstname = params[:firstname]
  u.lastname = params[:lastname]
  u.email = params[:email]
  u.password = Password.create("Maker20")
  u.perm = 1
  u.save

  @u = User.first(:email => params[:email])

  if @u && Password.new(@u.password) == params[:password]
    session[:id] = @u.id
    session[:visited] = true
    redirect '/dashboard'
  else

    redirect '/'
  end

end
post '/perms/edit' do
  u = User.first(:id => session[:id])
  if params[:permpassword] == ENV["permpass3"]
    u.perm = 3
    u.save
  elsif params[:permpassword] == ENV["permpass2"]
    u.perm = 2
    u.save
  elsif params[:permpassword] == ENV["permpass1"]
    u.perm = 1
    u.save
  elsif params[:permpassword] == ENV["permpass0"]
    u.perm = 0
    u.save
  else
    redirect '/'
  end
  puts u.perm
  redirect '/dashboard'

end
post '/test/email' do
  user = User.first(:id => session[:id])
  Pony.mail(
      :to => 'nqmetke@gmail.com',
      :from => 'betamakerspace@gmail.com',
      :subject=> "New Training Request from #{params[:firstname]} #{params[:lastname]}",
      :body => "This person would like to train on #{params[:date]} at #{params[:time]}. If you wish to contact #{params[:firstname]}, his/her email is #{params[:email]}",
      :via => :smtp,
      :via_options =>{
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'betamakerspace',
          :password             => 'wplmakerspace',
          :authentication       => :plain,
          :domain               => 'localhost.localdomain'


   }  )
  puts "Hey!"
  redirect '/#contact'
end
post '/blog/new' do
  blog = Post.new
  blog.title = params[:title]
  blog.content = params[:content]
  blog.date =params[:date]
  blog.draft   = (params.has_key? 'draft')? 1:0
  blog.type = "blog"
  blog.save
  if blog.save
    if ENV['SLACK_URL']
      payload = %({"channel": "#blogstuffs", "text": "Looks like *#{current_user.realName}* just *#{blog.draft == 1 ? 'drafted' : 'published'}* a *new* blog entry: _'#{blog.title}'_."})
      Net::HTTP.post_form URI(ENV['SLACK_URL']), {'payload' => payload}
    end
  else
  end
  redirect '/blog'
end
post '/pass/edit' do
  @u = User.first(:id => session[:id])
  puts Password.new(@u.password)
  puts Password.create(params[:oldPassword])

  if Password.new(@u.password) == params[:oldPassword]
    @u.password = Password.create(params[:newPassword])
    @u.save
  else
    redirect '/settings'
  end

redirect '/dashboard'
end
post '/post/create/update' do
  time = Time.new
  i = Post.new
  i.title = params[:title]
  i.content = params[:content]
  i.url = params[:url]
  i.date = time
  i.type = "update"
  i.save
  redirect '/dashboard'
end
post '/post/delete/:id' do
  p = Post.first(:id => params[:id])
  p.destroy
  redirect request.env["HTTP_REFERER"]
end
post '/email/web/suggest' do
    user = User.first(:id => session[:id])
  Pony.mail(
      :to => 'nqmetke@gmail.com',
      :from => 'betamakerspace@gmail.com',
      :subject=> "New suggestion from #{user.firstname} #{user.lastname}, email back #{user.email}",
      :body => "Their suggestion is this: #{params[:suggestion]}.",
      :via => :smtp,
      :via_options =>{
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'betamakerspace',
          :password             => 'wplmakerspace',
          :authentication       => :plain,

          :domain               => 'localhost.localdomain'


   }  )
  redirect '/dashboard'
end
post '/test' do
  puts "works here!"
  u = User.first(:email => params[:email])
  if u.firstname + " " + u.lastname == params[:name]
    puts u.firstname + " " + u.lastname
    @test = "What up, thanks for loggins in"
    puts "This is you!"
  end
end
  end




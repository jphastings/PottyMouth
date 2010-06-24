require 'rubygems'
require 'sinatra'
require 'json'
require 'db'
require 'haml'

set :sass, {:style => :compact }

helpers do
  def pie_chart(counts, title = "Swears in Github Repositories")
    pc = GoogleChart::PieChart.new('540x400', title,false)
    # How the shitsticks am I supposed to get lots of exciting and well spaced colours here without
    # resorting to HSV colour space mapping. Meh. Can't be arsed right now…
    counts.each do |swear|
      pc.data swear.swear,swear.all_count.to_i
    end
    pc.to_url
  end
end

# Github

post '/posthook' do
  require 'search_and_update'
  
  payload = JSON.parse(params[:payload])

  check_repo(
    :giturl => payload['repository']['url'].gsub("http://","git://")<<".git",
    :repo   => payload['repository']['name'],
    :user   => payload['repository']['owner']['name'],
    :hash   => payload['after']
  )
end

# Pages

get '/' do  
  haml :home
end

get '/howto' do  
  haml :howto
end

get '/details/:user' do
  "<h1>#{params[:user]}</h1><img src=\"/graphs/#{params[:user]}.png\"/><a href=\"/\">Backward!</a>"
end

get '/details/:user/:repo' do
  "<h1>#{params[:user]} : #{params[:repo]}</h1><img src=\"/graphs/#{params[:user]}/#{params[:repo]}.png\"/><a href=\"/\">Backward!</a>"
end

# Assets

get '/css/default.css' do
  sass :default
end

get '/graphs/overview.png' do
  require 'google_chart'
  
  redirect pie_chart(Swear.find(:all,:select => "swear,SUM(count) as all_count",:order => "all_count DESC",:group => :swear,:limit => 30)), 307
end

get '/graphs/:user.png' do
  require 'google_chart'
  
  redirect pie_chart(Swear.find(:all,:conditions => ["user = ?",params[:user]],:select => "swear,SUM(count) as all_count",:order => "all_count DESC",:group => :swear,:limit => 15),"Top 15 swears by #{params[:user]}"), 307
end

get '/graphs/:user/:repo.png' do
  require 'google_chart'
  
  redirect pie_chart(Swear.find(:all,:conditions => ["user = ? AND repo = ?",params[:user],params[:repo]],:select => "swear,SUM(count) as all_count",:order => "all_count DESC",:group => :swear,:limit => 15),"Top 15 swears by #{params[:user]} in #{params[:repo]}"), 307
end
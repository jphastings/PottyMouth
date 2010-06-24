require 'rubygems'
require 'sinatra'
require 'json'
require 'db'
require 'haml'

set :sass, {:style => :compact }

helpers do
  def pie_chart(counts)
    pc = GoogleChart::PieChart.new('540x400', "Swears in Github Repositories",false)
    counts.each do |swear,count|
      pc.data swear,count
    end
    pc.to_url
  end
end

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

get '/' do  
  haml :home
end

get '/howto' do  
  haml :howto
end

get '/graphs/overview.png' do
  require 'google_chart'
  
  redirect pie_chart(Swear.count(:group => :swear)), 307
end

=begin
get '/external/github/:user/:repo' do
  require 'search_and_update'
  check_repo(
    :giturl => "git://github.com/#{params[:user]}/#{params[:repo]}.git",
    :repo   => params[:repo],
    :user   => params[:user],
    :hash   => "" # need to change this?
  )
end
=end
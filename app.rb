require 'rubygems'
require 'sinatra'
require 'json'
require 'db'

helpers do
  def pie_chart(counts)
    graph = ""
    GoogleChart::PieChart.new('540x400', "Swears",false) do |pc|
      counts.each do |swear,count|
        pc.data swear,count

      end
      graph = pc.to_url
    end
    graph
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
  require 'google_chart'
  
  graph = pie_chart(Swear.count(:group => :swear))
  
  "<img src=\"#{graph}\" />"
end
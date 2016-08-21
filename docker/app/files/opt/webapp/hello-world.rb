require 'sinatra'
require 'redis'
 
set :bind, '0.0.0.0'

redis = Redis.new(:host => ENV["REDIS_HOST"] || "127.0.0.1" , :port => ENV["REDIS_PORT"] || 6379)

get '/' do
  redis.ping
  "Hello World!"
end
 

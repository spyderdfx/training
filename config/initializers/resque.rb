require 'resque/job_with_status'

uri = URI.parse("redis://localhost:6379/")
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

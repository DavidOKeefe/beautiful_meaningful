enable :sessions

get '/' do
  erb :index
end

get '/sign_in' do
  puts "did I get here?"
  @consumer = OAuth::Consumer.new(ENV['CONSUMER_KEY'],
    ENV['CONSUMER_SECRET'], :site => "https://api.twitter.com")

  puts "#{ENV['CONSUMER_KEY']}"
  puts "#{ENV['CONSUMER_SECRET']}"
  puts @consumer

  @request_token = @consumer.get_request_token(:oauth_callback => "http://127.0.0.1:9393/auth")

  puts "#{@request_token}"

  session[:request_token] = @request_token

  redirect @request_token.authorize_url
end


get '/auth' do
  @request_token = session[:request_token]

  @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  @user = User.create(username: @access_token.screen_name, oauth_token: @access_token.token, oauth_secret: @access_token.secret)

  erb :index
end

get '/sign_out' do
  session.clear
  redirect '/'
end

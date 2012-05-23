require 'sinatra'
require 'json'

# mime :json, 'application/json'

get '/contacts.json' do
  contacts = 
  [
    { :name => 'Fernand', age: 35, created_at: Time.now, updated_at: Time.now },
    { :name => 'Bozo'   , age: 35, created_at: Time.now, updated_at: Time.now }
  ]
  
  content_type :json
  contacts.to_json
end

post '/contacts' do
  contact = JSON.parse( params[:contact] ) 
  "Jesus is coming. Look busy!"
end
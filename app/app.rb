require 'sinatra'
require 'cartier'
require 'json'

get '/' do
  content_type 'application/json'
  {
    greeting: 'Welcome to the Cartier Navigation Service. You will find the following endpoints here',
    endpoints: [
      {
        http_verb: 'GET',
        description: 'distance using haversine calculation',
        url_pattern: '/distance/haversine/source/:source_lat/:source_long/target/:target_lat/:target_long'
      },
      {
        http_verb: 'GET',
        description: 'distance using equirectangular calculation',
        url_pattern: '/distance/equirectangular/source/:source_lat/:source_long/target/:target_lat/:target_long'
      },
      {
        http_verb: 'GET',
        description: 'midpoint calculation between two GPS Locations',
        url_pattern: '/distance/get_midpoint/source/:source_lat/:source_long/target/:target_lat/:target_long'
      },
      {
        http_verb: 'GET',
        description: 'bearing calculation between two GPS Locations',
        url_pattern: '/distance/get_bearing/source/:source_lat/:source_long/target/:target_lat/:target_long'
      },
      {
        http_verb: 'GET',
        description: 'GPS location calculation given start, bearing, and distance',
        url_pattern: '/destination_point/source/:source_lat/:source_long/bearing/:bearing/distance/:distance'
      }
    ]
  }.to_json
end

get '/echo' do
  { ping: 'pong' }.to_json
end

get '/distance/haversine/source/:source_lat/:source_long/target/:target_lat/:target_long' do
  source = Cartier::GPSLocation.new params[:source_lat].to_f, params[:source_long].to_f
  target = Cartier::GPSLocation.new params[:target_lat].to_f, params[:target_long].to_f
  content_type 'application/json'
  {
    distance: Cartier::Navigation.haversine_distance(source, target),
    metric: 'km'
  }.to_json
end

get '/distance/equirectangular/source/:source_lat/:source_long/target/:target_lat/:target_long' do
  source = Cartier::GPSLocation.new params[:source_lat].to_f, params[:source_long].to_f
  target = Cartier::GPSLocation.new params[:target_lat].to_f, params[:target_long].to_f
  content_type 'application/json'
  {
    distance: Cartier::Navigation.equirectangular_projection(source, target),
    metric: 'km'
  }.to_json
end

get '/distance/get_midpoint/source/:source_lat/:source_long/target/:target_lat/:target_long' do
  source = Cartier::GPSLocation.new params[:source_lat].to_f, params[:source_long].to_f
  target = Cartier::GPSLocation.new params[:target_lat].to_f, params[:target_long].to_f
  midpoint = Cartier::Navigation.get_midpoint(source, target)
  content_type 'application/json'
  {
    lat: midpoint.latitude,
    long: midpoint.longitude
  }.to_json
end

get '/distance/get_bearing/source/:source_lat/:source_long/target/:target_lat/:target_long' do
  source = Cartier::GPSLocation.new params[:source_lat].to_f, params[:source_long].to_f
  target = Cartier::GPSLocation.new params[:target_lat].to_f, params[:target_long].to_f
  content_type 'application/json'
  {
    bearing: Cartier::Navigation.get_bearing(source, target),
    metric: 'degrees'
  }.to_json
end

get '/destination_point/source/:source_lat/:source_long/bearing/:bearing/distance/:distance' do
  source = Cartier::GPSLocation.new params[:source_lat].to_f, params[:source_long].to_f
  destination_point = Cartier::Navigation.get_destination_point source, params[:bearing].to_f, params[:distance].to_f
  content_type 'application/json'
  {
    lat: destination_point.latitude,
    long: destination_point.longitude
  }.to_json
end

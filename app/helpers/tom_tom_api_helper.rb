require 'json'
require 'net/http'

module TomTomApiHelper

  BASE_URL = 'https://api.tomtom.com'
  SEARCH_VERSION_NUMBER = 2
  ROUTING_VERSION_NUMBER = 1

  def tom_tom_api_key
    tom_tom_config = YAML.load_file('config/tom_tom.yml')
    tom_tom_config['tom_tom_api_key']
  end

  # Converts an address to lon/lat coordinates
  # @param [String] address the address to convert to lon/lat coordinates
  # @return [Hash] a hash containing the lon/lat ex: {"lat"=>37.71982, "lon"=>-122.4356}
  def get_coordinates(address)
    end_point = "#{BASE_URL}/search/#{SEARCH_VERSION_NUMBER}/geocode/#{address}.JSON?key=#{tom_tom_api_key}"
    url = URI.parse(end_point)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url.request_uri)
    json_response = JSON.parse(response.body)
    json_response['results'][0]['position']
  end

  # Returns the route to the given location from the Tom Tom api
  # @param [Hash] from a hash containing the lon/lat coordinates of the starting location
  # @param [Hash] to a hash containing the lon/lat coordinates of the ending location
  # @return [Hash] a hash containing the response from Tom Tom with the route
  def get_route(from, to)
    coordinate_url_string = "#{from['lat']},#{from['lon']}:#{to['lat']},#{to['lon']}"
    end_point = "#{BASE_URL}/routing/#{ROUTING_VERSION_NUMBER}/calculateRoute/#{coordinate_url_string}/json?key=#{tom_tom_api_key}&instructionsType=tagged"
    url = URI.parse(end_point)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url.request_uri)
    JSON.parse(response.body)
  end
end

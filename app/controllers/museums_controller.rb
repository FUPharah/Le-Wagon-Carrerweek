# require 'mapbox-sdk'
# include Mapbox

# class MuseumsController < ApplicationController
#   def index
#     access_token = ENV['MAPBOX_API_KEY']
#     geocoding = GeocodingService.new(access_token)
#     response = geocoding.reverse_geocode(
#       lng: params[:lng],
#       lat: params[:lat],
#       types: 'museum'
#     )
#     museums_by_postcode = {}
#     response.features.each do |feature|
#       postcode = feature.properties['address']&.dig('postcode')
#       name = feature.properties['name']
#       if postcode && name
#         museums_by_postcode[postcode] ||= []
#         museums_by_postcode[postcode] << name
#       end
#     end
#     render json: museums_by_postcode
#   end
# end
require 'httparty'
class MuseumsController < ApplicationController

  def index
    response = HTTParty.get("https://api.mapbox.com/geocoding/v5/mapbox.places/#{params[:lng]},#{params[:lat]}.json?access_token=pk.eyJ1IjoiZnVwaGFyYWgiLCJhIjoiY2xma3pyemY4MDA5ZTNycG9nejJ5NTR6dyJ9.ERAV6WO8HyM-8o_tdxdcXA")
    puts response
    puts ENV['MAPBOX_API_KEY']

    if response.code != 200 || response.body.nil? || JSON.parse(response.body)['features'].empty?
      render json: { error: 'Unable to retrieve museums for the given location' }, status: :unprocessable_entity
    else
      museums = JSON.parse(response.body)['features']
        museums = museums.map do |museum|
          museum['place_name']
        # feature['properties'].fetch('address', nil)
        # museum['properties']
        end
      render json: museums
    end
  end
end

class Api::WeathersController < ApplicationController
  # skip_before_action :authenticate_user!
  # skip_before_action :verify_authenticity_token

  def index
    weather_response = Faraday.get("https://www.jma.go.jp/bosai/forecast/data/forecast/#{area_code}.json")
    weather_response_json = JSON.parse(weather_response.body)
    weekly_weather = weather_response_json[1]['timeSeries'][0]
    weekly_dates = weekly_weather['timeDefines']

    local_weekly_weather = weekly_weather['areas'][0]
    local_weekly_weather.delete('reliabilities')
    local_weekly_weather.delete('area')

    # shop = Shop.create!(owner_id: current_user.owner_id, city_code: city_code)

    forecast_weather_codes = local_weekly_weather['weatherCodes']
    forecast_pops = local_weekly_weather['pops']
    forecast_weather_codes.zip(forecast_pops, weekly_dates) do |code, pop, date|
      binding.irb
      # shop.shop_weathers.create!(forecast_weather_code: code, forecast_pop: pop, date: Date.parse(date))
    end

    render json: local_weekly_weather
  end

  private

  def area_code
    area_response = Faraday.get('https://www.jma.go.jp/bosai/common/const/area.json')
    area_response_json = JSON.parse(area_response.body)
    offices_area_code = area_response_json['class10s'][local_code]['parent']
    offices_area_code
  end

  def local_code
    area_response = Faraday.get('https://www.jma.go.jp/bosai/common/const/area.json')
    area_response_json = JSON.parse(area_response.body)
    class15s_area_code = area_response_json['class20s'][city_code]['parent']
    class10s_area_code = area_response_json['class15s'][class15s_area_code]['parent']
    class10s_area_code
  end

  def city_code
    city_code = '1310800' # 江東区
    city_code
  end
end

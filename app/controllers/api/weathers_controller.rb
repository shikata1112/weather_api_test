class Api::WeathersController < ApplicationController
  def index
    weather_response = Faraday.get("https://www.jma.go.jp/bosai/forecast/data/forecast/#{area_code}.json")
    weather_response_json = JSON.parse(weather_response.body)
    weekly_weather_area = weather_response_json[1]['timeSeries'][0]['areas'].first # area: ['東京', '伊豆諸島北部'...]
    weekly_weather_area.delete('reliabilities')
    render json: weekly_weather_area
  end

  private

  def area_code
    city_code = '1310800' # 江東区
    area_response = Faraday.get('https://www.jma.go.jp/bosai/common/const/area.json')
    area_response_json = JSON.parse(area_response.body)
    class15s_area_code = area_response_json['class20s'][city_code]['parent']
    class10s_area_code = area_response_json['class15s'][class15s_area_code]['parent']
    offices = area_response_json['class10s'][class10s_area_code]['parent']
    offices
  end
end

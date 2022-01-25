class Api::WeathersController < ApplicationController
  def index
    response = Faraday.get('https://www.jma.go.jp/bosai/common/const/area.json')
    response_json = JSON.parse(response.body)
  end
end

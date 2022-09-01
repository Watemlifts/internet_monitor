class V1::CountriesController < ApplicationController
  def index
    @countries = Country.with_enough_data.desc_score

    indicators = []
    @countries.each do |c|
      indicators |= c.indicators.in_current_index
    end
    render json: {
      data: @countries.map do |c|
        json = c.as_jsonapi
        json[:links][ :self ] = v1_country_url(c)

        json
      end,
      included: indicators.map(&:as_jsonapi)
    }
  end

  def show
    @country = Country.with_enough_data.find(params[:id])
    json = @country.as_jsonapi
    json[:links][ :self ] = v1_country_url(@country)
    render json: {
      data: json,
      included: @country.indicators.in_current_index.map(&:as_jsonapi)
    }
  end
end

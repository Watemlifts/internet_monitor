class V1::RegionsController < ApplicationController
  def index
    @regions = Region.order('iso3_code asc')

    indicators = []
    @regions.each do |c|
      indicators |= c.indicators.in_current_index
    end
    render json: {
      data: @regions.map do |c|
        json = c.as_jsonapi
        json[:links][ :self ] = v1_region_url(c)

        json
      end,
      included: indicators.map(&:as_jsonapi)
    }
  end

  def show
    @region = Region.find(params[:id])
    json = @region.as_jsonapi
    json[:links][ :self ] = v1_region_url(@region)
    render json: {
      data: json,
      included: @region.indicators.in_current_index.map(&:as_jsonapi)
    }
  end
end

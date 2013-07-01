class CountryCategoriesController < ApplicationController
  def show
    # no longer required, route has moved to countries#activity
    countryCategory = CountryCategory.find( params[:id] );

    @country_names = Country.select("id, name, score").select{|c| !c.score.nil?}.sort_by{|c| c.name}
    @country = countryCategory.country
    @category = countryCategory.category
  end

end
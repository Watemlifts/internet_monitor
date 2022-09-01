require 'spec_helper'

describe('countries/_nav_list') do
  let(:country) { Country.find_by_iso3_code('IRN') }

  subject { rendered }

  before do
    render
  end

  it {
    should have_css '.countries-nav-list'
  }

  it {
    should have_css 'a', text: country.name
  }

  it {
    should have_css "a[href*='#{category_country_path country, category_slug: 'access'}']"
  }
end

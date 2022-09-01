require 'spec_helper'

describe('datum_sources/_api_block') do
  let(:ds_aktv) { DatumSource.find_by_admin_name 'ds_aktv' }
  let(:country) { Country.find_by_name 'Iran' }

  subject { rendered }

  before do
    assign(:country, country)
    render partial: 'datum_sources/api_block', object: ds_aktv
  end

  it {
    should have_css '.block'
  }

  it {
    should have_css %(.block[data-ds-id="#{ds_aktv.id}"])
  }

  it {
    should have_css %(.block[data-ds-name="#{ds_aktv.admin_name}"])
  }

  it {
    should have_css %(.block[data-country-iso3="#{country.iso3_code}"])
    should have_css %(.block[data-country-iso2="#{country.iso_code}"])
  }
end

require 'spec_helper'

describe('data/_indicators_filtering_mo') do
  let(:country) { Country.find_by_iso3_code('IRN') }

  let(:category) { Category.find_by_slug('control') }
  let(:group) { Group.find_by_admin_name 'filtering_mo' }

  let(:grouped) do
    category.data.indicators.in_category_page.most_recent.for(country).group_by do |i|
      i.source.group
    end
  end

  subject { rendered }

  before do
    assign(:category, category)
    render 'data/indicators_filtering_mo', indicators_filtering_mo: grouped[group], group: group
  end

  it {
    should have_css 'div.indicators.indicators-filtering_mo'
  }

  it {
    should have_css 'h2', text: group.public_name, visible: false
  }

  it {
    should have_css 'dl'
  }

  it {
    should have_css '.indicators-label span', text: 'Low'
    should have_css '.indicators-label span', text: 'Medium'
    should have_css '.indicators-label span', text: 'High'
  }
end

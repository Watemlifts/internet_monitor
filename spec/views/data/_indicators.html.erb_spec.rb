require 'spec_helper'

describe('data/_indicators') do
  let(:country) { Country.find_by_iso3_code('IRN') }

  subject { rendered }

  context('access indicators') do
    let(:category) { Category.find_by_slug('access') }
    let(:grouped) do
      category.data.indicators.in_category_page.most_recent.for(country).group_by do |i|
        i.source.group
      end
    end
    let(:group) { grouped.first }

    before do
      assign(:category, category)
      render 'data/indicators', indicators: group[1], group: group[0]
    end

    it {
      should have_css "div.indicators.indicators-#{group[0].admin_name}"
    }

    it {
      should have_css 'h2', text: group[0].public_name
    }

    it {
      should have_css 'dl'
    }

    it {
      should have_css '.indicators-label span', text: 'worst'
    }
  end
end

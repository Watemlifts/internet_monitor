require 'spec_helper'

describe('shared/widgets/_category_selector') do
  subject { rendered }

  context('no country') do
    before do
      render
    end

    it {
      should have_css '.category-selector'
    }

    it {
      should_not have_css 'li:first a', text: 'Overview'
    }

    it {
      should have_css 'li:first a', text: 'Access'
    }

    it {
      should have_css 'li:nth-child(2) a', text: 'Control'
    }

    it {
      should have_css 'li:last a', text: 'Activity'
    }
  end

  context('country') do
    let(:country) { Country.find_by_iso3_code('IRN') }

    before do
      assign(:country, country)
      render
    end

    it {
      should have_css '.category-selector'
    }

    it {
      should have_css 'li:first a', text: 'Overview'
    }

    it {
      should have_css 'li:nth-child(2) a', text: 'Access'
    }

    it {
      should have_css 'li:nth-child(3) a', text: 'Control'
    }

    it {
      should have_css 'li:last a', text: 'Activity'
    }
  end
end

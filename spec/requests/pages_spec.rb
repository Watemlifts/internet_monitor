require 'spec_helper'

# refinery pages
describe('pages requests') do
  subject { page }

  describe 'get /home', js: true do
    before { visit refinery.root_path }

    it {
      should have_title 'Home | Internet Monitor'
    }

    it('should have FilmRoll') {
      should have_css '.carousel .film_roll_wrapper'
    }

    describe('trending') do
      it('should have a map') {
        should have_css '.trending li a .static-map'
      }

      it('map should be a simple static img') {
        should have_css '.static-map img[src*="irn"]'
      }
    end

    it('should not include jQuery Geo on every page') {
      should_not have_css 'script[src*="jquery.geo"]', visible: false
    }
  end

  describe('get /about') do
    before { visit refinery.marketable_page_path('about') }

    it {
      should have_title 'About | Internet Monitor'
    }

    it {
      should have_css 'h1', text: 'About'
    }

    it {
      should have_css 'body.refinery-pages'
    }

    it {
      should have_css '.refinery-pages #body_content'
    }

    it {
      should have_css '#body_content #body_content_title'
    }

    it {
      should have_css 'section#body'
    }

    it {
      should have_css 'section#side_body'
    }
  end

  describe('get /sources') do
    before { visit refinery.marketable_page_path('sources') }

    it {
      should have_css 'h1', text: 'Data'
    }

    it {
      should have_css 'section#body'
    }

    it {
      should have_css 'section#side_body'
    }
  end

  describe('get /access') do
    before { visit refinery.marketable_page_path('access') }

    it('should have page-specific class') {
      should have_css 'body.show-access'
    }

    it {
      should have_css 'h1', text: 'Access'
    }
  end

  context('from user weight') do
    let(:country) { Country.find_by_iso3_code('CHN') }

    let(:category) { Category.find_by_name('Access') }

    before do
      visit "#{category_country_path(country, category_slug: 'access')}#adoption=1.5"
    end

    describe('move to page') do
      before { visit refinery.marketable_page_path('about') }

      it {
        current_url.should_not match 'adoption'
      }
    end
  end
end

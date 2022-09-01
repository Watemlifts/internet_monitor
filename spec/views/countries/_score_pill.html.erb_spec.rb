require 'spec_helper'

describe('countries/_score_pill') do
  subject { rendered }

  context('normal country') do
    let(:country) { Country.find_by_iso3_code('IRN') }

    context('normal display') do
      before do
        assign(:country, country)
        render 'countries/score_pill', country: country
      end

      it {
        should have_css '.score-pill'
        should have_css ".score-pill[data-country-id='#{country.id}']"
      }

      it {
        should have_css "a[href*='#{category_country_path country, category_slug: 'access'}'].country-name",
                        text: country.name
        should have_css "a[title='#{country.name}']"
      }

      it {
        should have_css 'span.header', text: 'score'
      }

      it {
        should have_css 'span.imon-rank', text: '#2'
      }

      it {
        should have_css 'span.imon-score', text: number_with_precision(country.score, { precision: 2 }), exact: true
      }

      it {
        should have_css 'a.user-score'
      }

      it {
        should have_css 'a.user-rank'
      }

      it {
        should have_css 'span.help', text: '?'
      }
    end

    context('trending display') do
      before do
        render 'countries/score_pill', country: country, show_user: false
      end

      it {
        should have_css '.score-pill'
      }

      it {
        should have_css '.score-pill.no-user'
      }

      it {
        should_not have_css 'a.user-score'
      }

      it {
        should_not have_css 'a.user-rank'
      }
    end
  end
end

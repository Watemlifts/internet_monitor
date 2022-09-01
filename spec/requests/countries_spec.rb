require 'spec_helper'

describe 'countries requests', js: true do
  let(:access) { Category.find_by_slug 'access' }
  let(:groups) { DatumSource.where({ category_id: access.id }).map { |ds| ds.group }.uniq }
  let(:group_count) { groups.count }
  subject { page }

  shared_examples_for('weight_slider') do
    it('should have weight_slider link') {
      should have_selector('a.toggle-weight-sliders')
      should have_css '#configure-panel.hidden', visible: false
    }

    describe('click toggle-weight-sliders') do
      before do
        page.execute_script("$('.toggle-weight-sliders').click( )")
      end

      it('should show configure panel') {
        find('#configure-panel').visible?.should be_true
      }

      it('should have weight sliders') {
        should have_css '#configure-panel #weight-sliders'
      }

      it {
        should have_css '#weight-sliders .weight-slider', count: group_count
      }

      it {
        should_not have_css '#weight-sliders h4', text: 'ACCESS'
      }

      it {
        should_not have_css '#weight-sliders h4', text: 'CONTROL'
      }

      it {
        should have_css 'ul.weight-sliders-list', count: 1
      }

      it('should hide weight-sliders') {
        page.execute_script("$('.toggle-weight-sliders').click( )")
        should have_css '#configure-panel', count: 0
      }
    end
  end

  describe('get /countries index') do
    let(:country) { Country.find_by_iso3_code('CHN') }
    let(:country2) { Country.find_by_iso3_code('IRN') }
    let(:country_no_score) { Country.find_by_iso3_code('USA') }

    before do
      visit(countries_path)
    end

    it {
      should have_title 'Countries | Internet Monitor'
    }

    it_should_behave_like('weight_slider')

    it {
      should have_css '.score-pill', count: 2
    }

    # full tests for weight slider/scoreKeeper on countries page with multiple score pills

    describe('scoreKeeper') do
      context('without user score') do
        it {
          should_not have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-rank", visible: false
          should_not have_css ".score-pill[data-country-id='#{country.id}'] .user-rank.updated", visible: false
        }
      end

      context('with sliding a slider') do
        before do
          page.execute_script("$('.toggle-weight-sliders').click( )")
          page.execute_script(%q[$('[name="adoption"]').val( 0.5 ).trigger('input')])
          sleep 1
        end

        it {
          current_url.should match 'adoption=0.5'
        }

        it {
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '6.25'
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-rank", text: '1'
        }

        it {
          should have_css ".score-pill[data-country-id='#{country2.id}'] .user-score", text: '3.12'
        }

        it('should not updated score pills for countries without enough data') {
          should_not have_css ".score-pill[data-country-id='#{country_no_score.id}'] .user-score.updated"
        }

        describe('refresh') do
          before do
            visit current_url
          end

          it('should maintain state') {
            should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
            should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '6.25'
          }
        end
      end

      context('check default weight') do
        before do
          page.execute_script("$('.toggle-weight-sliders').click( )")
        end

        it {
          slider_val = page.evaluate_script %q[$('[name="adoption"]').val( )]
          slider_val.should eq('1')
        }
      end
    end
  end

  context('with scoreKeeper state in url') do
    let(:country) { Country.find_by_iso3_code('CHN') }

    let(:category) { Category.find_by_name('Access') }

    context('with user weight') do
      before do
        visit "#{category_country_path(country, category_slug: 'access')}#adoption=1.5"
        page.execute_script "$('.toggle-weight-sliders').click( )"
      end

      it {
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '8.75'
      }

      it {
        slider_val = page.evaluate_script %q[$('[name="adoption"]').val( )]
        slider_val.should eq('1.5')
      }

      describe('reset') do
        before do
          click_button 'Reset'
        end

        it {
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '7.5'
        }
      end

      describe('move to another page') do
        before do
          visit countries_path
        end

        it('should maintain state') {
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
          should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: '8.75'
        }
      end
    end

    context('with default weight') do
      before do
        visit "#{countries_path}#adoption=1"
      end

      it {
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score.updated"
        should have_css ".score-pill[data-country-id='#{country.id}'] .user-score", text: country.score.round(2)
      }
    end
  end

  shared_examples_for('category_selector') do
    it('should link to the country overview') {
      should have_css ".category-selector a[href*='#{country_path country}']", text: 'OVERVIEW'
    }

    it('should have category selector links') {
      should have_css ".category-selector a[href*='#{category_country_path country, category_slug: 'access'}']"
      should have_css ".category-selector a[href*='#{category_country_path country, category_slug: 'control'}']"
      should have_css ".category-selector a[href*='#{category_country_path country, category_slug: 'activity'}']"
    }
  end

  describe('get /countries/:id') do
    context('with normal country') do
      let(:country) { Country.find_by_iso3_code('IRN') }

      before { visit country_path(country) }

      it {
        should have_title "#{country.name.titleize} | Internet Monitor"
      }

      it {
        should have_selector 'h1', text: country.name
      }

      it_should_behave_like('weight_slider')

      it {
        should_not have_css ".score-pill[data-country-id='#{country.id}']"
      }

      it_should_behave_like('category_selector')
      it('should not have any category') {
        should_not have_selector '.category-selector a.selected'
      }

      it('should not have indicators') {
        should_not have_selector '.country .indicators,.country .url-lists,.country .html-blocks,.country .images'
      }

      it('map should no longer be geomap') {
        should_not have_css '.sidebar .geomap'
      }

      it('should no-longer color all known countries') {
        # this is a side-effect of #7241 & may need to be undone
        should_not have_css '.sidebar .geomap'
      }
    end
  end

  describe('get /countries/:friendly_id') do
    context('with normal country') do
      let(:country) { Country.find_by_iso3_code('IRN') }

      before { visit country_path(country) }

      it {
        current_url.should match country.friendly_id
      }
    end
  end

  describe('get /countries/:id/access') do
    context('with normal country') do
      let(:country) { Country.find_by_iso3_code('IRN') }
      let(:category) { Category.find_by_name('Access') }

      before do
        visit category_country_path(country, category_slug: 'access')
      end

      it {
        should have_title("#{country.name.titleize} Access | Internet Monitor")
      }

      it_should_behave_like('weight_slider')

      it {
        should have_css ".score-pill[data-country-id='#{country.id}']"
      }

      describe('click user score in pill') do
        before do
          page.execute_script("$('a.user-score').click( )")
        end

        it {
          find('#configure-panel').visible?.should be_true
        }
      end

      describe('click user rank in pill') do
        before do
          page.execute_script("$('a.user-rank').click( )")
        end

        it {
          find('#configure-panel').visible?.should be_true
        }
      end

      it_should_behave_like('category_selector')

      it('should have category selected') {
        should have_selector(".category-selector a[href*='#{category_country_path(country,
                                                                                  category_slug: 'access')}'].selected")
      }
    end

    context('with country missing access CMS page') do
      let(:country) { Country.find_by_iso3_code('CHN') }
      let(:category) { Category.find_by_name('Access') }

      before do
        visit category_country_path(country, category_slug: 'access')
      end

      it {
        should have_title("#{country.name.titleize} Access | Internet Monitor")
      }
    end
  end

  describe 'get /countries/:id/control' do
    let(:country) { Country.find_by_iso3_code('IRN') }
    let(:category) { Category.find_by_name('Control') }

    before do
      visit category_country_path(country, category_slug: 'control')
    end

    it {
      should have_title("#{country.name.titleize} Control | Internet Monitor")
    }

    it_should_behave_like('weight_slider')

    it {
      should_not have_css ".score-pill[data-country-id='#{country.id}']"
    }

    it_should_behave_like('category_selector')
    it('should have category selected') {
      should have_selector(".category-selector a[href*='#{category_country_path(country,
                                                                                category_slug: 'control')}'].selected")
    }
  end

  describe('get /countries/:id/activity') do
    let(:country) { Country.find_by_iso3_code('IRN') }
    let(:category) { Category.find_by_name('Activity') }

    before do
      visit category_country_path(country, category_slug: 'activity')
    end

    it {
      should have_title("#{country.name.titleize} Activity | Internet Monitor")
    }

    it_should_behave_like('weight_slider')

    it {
      should_not have_css ".score-pill[data-country-id='#{country.id}']"
    }

    it_should_behave_like('category_selector')
    it('should have category selected') {
      should have_selector(".category-selector a[href*='#{category_country_path(country,
                                                                                category_slug: 'activity')}'].selected")
    }
  end
end

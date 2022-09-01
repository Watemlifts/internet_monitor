require 'spec_helper'

# simple interaction tests for application layout elements
describe 'layout requests', js: true do
  subject { page }

  describe('get /') do
    before { visit refinery.root_path }

    describe('country selector') do
      describe('click countries') do
        before do
          click_link 'countries'
          sleep 1
        end

        it {
          should have_css '.countries-nav-list.expanded'
        }

        it {
          # countries without enough data should not show in this list
          should_not have_css '.countries-nav-list a', text: 'UNITED STATES'
        }

        describe('click countries twice') do
          before do
            click_link 'countries'
          end

          it('should hide country list') {
            should_not have_css '.countries-nav-list.expanded'
          }
        end
      end
    end

    describe('category selector') do
      it {
        # moved to country views only
        should_not have_css '.category-selector'
      }

      describe('click categories') do
        it {
          # there is no longer a link named categories
          should_not have_css 'a', text: 'categories'
        }
      end

      context('with countries expended, click categories') do
        it('should close countries') {
          click_link 'countries'
          # there is no longer a link named categories
          # click_link 'categories'
          should have_css '.countries-nav-list.expanded'
          should_not have_css '.category-selector.expanded'
        }
      end
    end
  end
end

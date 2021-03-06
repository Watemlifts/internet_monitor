require 'spec_helper'

describe ( 'layouts/application' ) {
  subject { rendered }

  context ( 'default layout' ) {
    let ( :groups  ) { Group.all }

    before {
      assign( :groups, groups )
      render 
    }

    it ( 'should have header links' ) {
      should have_css 'header nav'

      should have_css "header a[href*='#{refinery::marketable_page_path('about')}']"
      should have_css "header a[href*='#{refinery::marketable_page_path('research')}']"
      should have_css "header a[href*='#{refinery::marketable_page_path('sources')}']"
      should have_css "header a[href*='#{refinery::marketable_page_path('faq')}']"
      should have_css "header a[href$='#{refinery::blog_root_path}']"
    }

    it ( 'should have countries dropdown' ) {
      should_not have_css "header a[href*='#{countries_path}']"
      should have_css 'header a.data-nav-countries', text: 'countries'
    }

    it {
      should have_css "header a[href*='#{map_path}']"
    }

    it {
      should have_css '.data-nav-countries'
      should have_css '.countries-nav-list'
      should_not have_css '.countries-nav-list.expanded'
    }

    it {
      # categories now always visible, don't need a toggle
      should_not have_css '.data-nav-categories'
    }

    it ( 'should no longer have country data loading screen (dev env, only)' ) {
      should_not have_css '.score-keeper-loader', visible: false
    }

    it ( 'should have footer links' ) {
      should have_css( 'footer nav' );

      should have_css "footer a[href*='#{refinery::marketable_page_path('about')}']"
      should have_css "footer a[href*='#{refinery::marketable_page_path('terms-of-service')}']", text: 'terms & privacy'
      should have_css "footer a[href*='#{refinery::marketable_page_path('contact')}']", text: 'contact'
      should have_css "footer a[href$='#{refinery::blog_root_path}']"
      should_not have_css 'footer li', text: 'MAILING LIST'
    }

    it ( 'should have cc link' ) {
      should have_css "footer span.cc a[href='http://creativecommons.org/licenses/by/3.0/']", text: 'Creative Commons'
    }
  }
}

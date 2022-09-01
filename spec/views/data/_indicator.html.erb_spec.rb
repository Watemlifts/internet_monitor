require 'spec_helper'

describe('data/_indicator') do
  let(:country) { Country.find_by_iso3_code('IRN') }

  subject { rendered }

  shared_examples_for('indicator') do
    it {
      should have_css 'dt', text: indicator.name
    }

    it {
      should have_css "dt a[title='Source: #{ds.source_name}']"
    }

    it('should link to the sources cms page') {
      should have_css 'dt a[href*="/sources"]'
    }

    it {
      # moved to span next to inner bar
      should_not have_css 'dd[title]'
    }

    it {
      should have_css 'dd span.indicator-bar-outer'
    }

    it {
      should have_css 'dd span.indicator-bar-outer span.indicator-bar-inner'
    }

    it {
      should have_css 'dd span.indicator-bar-outer span.original-value'
    }

    it {
      should have_css 'span.indicator-bar-inner ~ span.original-value'
    }

    it {
      should have_css 'span.original-value',
                      text: "#{ds.display_prefix}#{number_with_precision(indicator.original_value,
                                                                         { precision: 0,
                                                                           delimiter: ',' })}#{ds.display_suffix}"
    }
  end

  context('indicators') do
    context('with prefix') do
      let(:ds) { DatumSource.find_by_admin_name('ds_fixed_monthly') }
      let(:indicator) { country.indicators.where({ datum_source_id: ds.id }).first }

      before do
        assign(:category, ds.category)
        render 'data/indicator', indicator: indicator
      end

      it_should_behave_like 'indicator'
    end

    context('with suffix') do
      let(:ds) { DatumSource.find_by_admin_name('ds_lit_rate') }
      let(:indicator) { country.indicators.where({ datum_source_id: ds.id }).first }

      before do
        assign(:category, ds.category)
        render 'data/indicator', indicator: indicator
      end

      it_should_behave_like 'indicator'
    end

    context('with hidden original_value') do
      let(:ds) { DatumSource.find_by_admin_name('ds_mob_scr') }
      let(:indicator) { country.indicators.where({ datum_source_id: ds.id }).first }

      before do
        assign(:category, ds.category)
        render 'data/indicator', indicator: indicator
      end

      it {
        should_not have_css 'dd span.indicator-bar-outer span.original-value'
      }
    end
  end
end

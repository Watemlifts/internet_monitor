require 'spec_helper'

describe('Datum model') do
  let(:ds_pct_inet) { DatumSource.find_by_admin_name('ds_pct_inet') }
  let(:ds_social) { DatumSource.find_by_admin_name('ds_social') }
  let(:ds_consistency) { DatumSource.find_by_admin_name('ds_consistency') }
  let(:iran) { Country.find_by_iso3_code('IRN') }
  let(:china) { Country.find_by_iso3_code('CHN') }
  let(:usa) { Country.find_by_iso3_code('USA') }

  let(:d_pct_inet_iran) do
    Datum.where({
                  datum_source_id: ds_pct_inet.id,
                  country_id: iran.id
                }).first
  end

  let(:d_pct_inet_china) do
    Datum.where({
                  datum_source_id: ds_pct_inet.id,
                  country_id: china.id
                }).first
  end

  let(:d_social_china) do
    Datum.where({
                  datum_source_id: ds_social.id,
                  country_id: china.id
                }).first
  end

  let(:d_consistency_iran) do
    Datum.where({
                  datum_source_id: ds_consistency.id,
                  country_id: iran.id
                }).first
  end

  context('with valid data') do
    it {
      d_pct_inet_iran.should be_valid
    }

    describe('value') do
      it {
        d_pct_inet_iran.value.should eq(0.0)
      }

      it {
        d_pct_inet_china.value.should eq(1.0)
      }
    end
  end

  context('only indicators') do
    it {
      Datum.indicators.count.should_not eq(0)
    }
  end

  context('only non-indicators') do
    it {
      # there are some like herdict & morningide
      Datum.non_indicators.count.should eq(4)
    }
  end

  context('with pre-normalized DatumSource') do
    # pre-normalized datum values equal their original_value
    # unrelated to other countries

    it {
      d_social_china.value.should eq(3.0)
    }

    it {
      d_consistency_iran.value.should eq(1.0)
    }
  end
end

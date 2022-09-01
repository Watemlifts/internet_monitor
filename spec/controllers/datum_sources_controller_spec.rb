require 'spec_helper'

describe(DatumSourcesController) do
  context('with json api datum_source') do
    describe('GET show.json') do
      let(:ds) { DatumSource.find_by_admin_name 'ds_aktv' }

      before do
        get :show, id: ds.id, format: :json
      end

      it {
        response.code.should eq('200')
      }
    end
  end

  context('with non-api datum_source') do
    describe('GET show.json') do
      let(:ds) { DatumSource.find_by_admin_name 'ds_fixed_monthly_gdp' }

      before do
        get :show, id: ds.id, format: :json
      end

      it {
        response.code.should eq('404')
      }
    end
  end
end

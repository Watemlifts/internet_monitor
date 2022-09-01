require 'spec_helper'

describe('datum_sources.json requests') do
  describe('get /datum_sources/:id.json') do
    context('with xml datum_source') do
      let(:ds) { DatumSource.find_by_admin_name 'ds_aktv' }

      before do
        visit datum_source_path ds, format: :xml
      end

      it {
        page.status_code.should eq(200)
      }

      it {
        Hash.from_xml(source)['locations'].should_not eq(nil)
      }
    end
  end
end

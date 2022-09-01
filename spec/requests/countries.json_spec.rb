require 'spec_helper'

describe('countries.json requests') do
  describe('get /countries.json') do
    before do
      visit countries_path(format: :json)
    end

    it {
      page.status_code.should eq(200)
    }

    describe('json') do
      let(:parsed) { JSON.parse(page.source) }

      it {
        parsed.class.should eq(Hash)
        parsed['cs'].should_not eq(nil) # countries
      }

      describe('countries hash') do
        let(:countries) { parsed['cs'] }

        describe('country hash') do
          let(:country) { countries[0]['c'] }

          it {
            country['id'].should_not eq(nil)
            country['n'].should eq(nil) # name (no longer used)
            country['s'].should_not eq(nil) # score
          }

          it {
            country['data'].should_not eq(nil) # indicators
            country['data'].class.should eq(Array)
          }

          describe('indicator hash') do
            let(:indicator) { country['data'][0] }

            it {
              indicator['v'].should_not eq(nil) # value
              indicator['nv'].should_not eq(nil) # normalized_value
              indicator['sid'].should_not eq(nil) # source_id
              indicator['dw'].should_not eq(nil) # default_weight
              indicator['c'].should eq(nil) # category (no longer used)

              indicator['g'].should_not eq(nil) # group
              indicator['g'].class.should eq(Integer)
            }
          end
        end
      end
    end
  end
end

require 'spec_helper'

describe('Category model') do
  subject { category }

  context('access') do
    let(:category) { Category.find_by_slug 'access' }

    describe('with valid data') do
      it {
        should be_valid
      }

      it {
        category.slug.should eq('access')
      }

      it {
        category.name.should eq('Access')
      }

      it {
        should respond_to :data
      }
    end
  end
end

require 'spec_helper'

describe('blog requests') do
  subject { page }

  describe('get /blog') do
    before { visit refinery.blog_root_path }

    it {
      should have_css 'body.refinery-blog-posts'
    }

    it {
      should have_css 'body.refinery-blog-posts.index'
    }
  end
end

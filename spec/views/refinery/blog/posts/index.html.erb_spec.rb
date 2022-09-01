require 'spec_helper'
require 'will_paginate/array'

def page_title
  'Blog'
end

include Refinery::Pages::ContentPagesHelper

describe('refinery/blog/posts/index') do
  subject { rendered }

  context('default view') do
    let(:page) { Refinery::Page.find_by_slug('blog') }
    let(:posts) { Refinery::Blog::Post.all.paginate(page: 1, per_page: 2) }

    before do
      assign :page, page
      assign :posts, posts
      render
    end

    it {
      should have_css 'h1', text: 'Blog'
    }
  end
end

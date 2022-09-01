# This migration comes from refinery_pages (originally 20151103211604)
class FixSlugFormatInRefineryPageParts < ActiveRecord::Migration
  def change
    ::Refinery::PagePart.all.each do |pp|
      pp.slug = pp.slug.downcase.tr(' ', '_')
      pp.save!
    end
  rescue NameError
    warn 'Refinery::PagePart was not defined!'
  end
end

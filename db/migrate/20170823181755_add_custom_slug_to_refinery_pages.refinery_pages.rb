# This migration comes from refinery_pages (originally 20140105190324)
class AddCustomSlugToRefineryPages < ActiveRecord::Migration
  def up
    add_column :refinery_pages, :custom_slug, :string if page_column_names.exclude?('custom_slug')
  end

  def down
    remove_column :refinery_pages, :custom_slug if page_column_names.include?('custom_slug')
  end

  private

  def page_column_names
    return [] unless defined?(::Refinery::Page)

    Refinery::Page.column_names.map(&:to_s)
  end
end

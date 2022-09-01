module DataHelper
  def retriever_class_name(datum)
    datum.source.retriever_class.class.name.underscore.dasherize
  end

  def refinery_page(datum)
    page = Refinery::Page.by_slug("#{datum.source.admin_name}_#{datum.value_id}")
    page = Refinery::Page.by_slug(datum.source.admin_name.to_s) unless page.present?
    page
  end
end

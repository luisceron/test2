module LinksHelper
  def link_to_base path, icon, text, classe
    link_to content_tag(:i, "", :class => "fa fa-"+icon.to_s+" space-after-icon")+text, path, class: classe
  end

  def link_to_back path
    link_to_base(path, 'arrow-circle-left', t('link.back'), 'btn btn-default')
  end

  def save_button
    render partial: 'shared/button_save'
  end
end

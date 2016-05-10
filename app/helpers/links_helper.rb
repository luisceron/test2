module LinksHelper
  def link_to_base path, icon, text, classe
    link_to content_tag(:i, "", :class => "fa fa-"+icon.to_s+" space-after-icon")+text, path, class: classe
  end

  def link_icon_to_base path, icon, classe, options = {}
    method = options[:method]
    data = options[:data]

  	link_to content_tag(:i, "", :class => "fa fa-"+icon.to_s), path, class: classe, method: method, data: data
  end

  def save_button
    render partial: 'shared/button_save'
  end
  
  def link_to_back path
    link_to_base(path, 'arrow-circle-left', t('link.back'), 'btn btn-default')
  end

  def link_to_edit path
  	 link_to_base(path, 'fa fa-pencil-square-o', t('link.edit'), 'btn btn-primary space-links')
  end

  def link_icon_to_edit path
  	link_icon_to_base(path, 'fa fa-pencil-square-o', "btn btn-xs btn-primary")
  end

  def link_icon_to_destroy path
  	link_icon_to_base(path, 'fa fa-trash', "btn btn-xs btn-danger", { method: :delete, data: {confirm: t('action.sure')} })
  end
end

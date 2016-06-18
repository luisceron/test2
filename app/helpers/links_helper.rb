module LinksHelper
  def save_button
    render partial: 'shared/button_save'
  end

  def link_specific_icon_to path, text, options = {}
    classe = options[:class]
    icon   = options[:icon]
    with_icon_base path, text, "btn-"+classe.to_s+" space-links", icon
  end

  def link_only_icon_to_edit path
    only_icon_base(path, 'pencil-square-o', "btn-xs btn-primary")
  end

  def link_only_icon_to_destroy path
    only_icon_base(path, 'trash', "btn-xs btn-danger", { method: :delete, data: {confirm: t('action.sure')} })
  end

  def link_with_icon_to_back path
    with_icon_base(path, t('link.back'), ' btn-default', 'arrow-circle-left')
  end

  def link_with_icon_to_edit path
    with_icon_base(path, t('link.edit'), 'btn-primary space-links', 'pencil-square-o')
  end

  # def link_with_icon_to_new path, model
  #   with_icon_base(path, t('action.new', model: model.model_name.human), 'btn-primary space-links', 'plus')
  # end

  # def link_with_icon_to_new_fem path, model
  #   with_icon_base(path, t('action.new_fem', model: model.model_name.human), 'btn-primary space-links', 'plus')
  # end

  private
    def only_icon_base path, icon, classe, options = {}
      method = options[:method]
      data   = options[:data]

      link_to content_tag(:i, "", :class => "fa fa-"+icon.to_s), path, class: "btn "+classe, method: method, data: data
    end

    def with_icon_base path, text, classe, icon
      link_to content_tag(:i, "", :class => "fa fa-"+icon.to_s+" space-after-icon")+text, path, class: "btn "+classe
    end
end

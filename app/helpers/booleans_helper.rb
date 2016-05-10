module BooleansHelper
  def icon_for_boolean attribute
    content_tag(:div, '', class: "#{ attribute ? 'fa fa-check-square-o' : 'fa fa-minus' }")
  end

  def badge_for_boolean attribute
    content_tag(:div, attribute ? t('link.text-yes') : t('link.text-no'),  class: "label label-#{attribute ? "success" : "danger"}")
  end
end

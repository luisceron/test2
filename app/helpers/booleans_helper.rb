module BooleansHelper
  # def icon_for_boolean attribute
  #   content_tag(:div, '', class: "#{ attribute ? 'fa fa-check-square-o' : 'fa fa-minus' }")
  # end

  def badge_for_admin
    content_tag(:div, User.human_attribute_name(:admin), class: "label label-success")
  end

  def account_type_badge_for account_type
    case account_type
      when 1 then content_tag(:div, 'C', class: "label label-success")
      when 2 then content_tag(:div, 'P', class: "label label-primary")
      when 3 then content_tag(:div, 'M', class: "label label-default")
    end
  end
end

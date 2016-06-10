module BooleansHelper
  # def icon_for_boolean attribute
  #   content_tag(:div, '', class: "#{ attribute ? 'fa fa-check-square-o' : 'fa fa-minus' }")
  # end

  def badge_for_admin
	content_tag(:div, User.human_attribute_name(:admin), class: "label label-success")
  end
end

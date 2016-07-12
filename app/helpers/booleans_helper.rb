module BooleansHelper
  # def icon_for_boolean attribute
  #   content_tag(:div, '', class: "#{ attribute ? 'fa fa-check-square-o' : 'fa fa-minus' }")
  # end

  def badge_for_admin
    content_tag(:div, User.human_attribute_name(:admin), class: "label label-success")
  end

  def badge_for_account_type account_type
    case account_type.to_sym
      when :current_account then return content_tag(:div, Account.human_attribute_name(:current_letter), class: "label label-success")
      when :saving_account  then return content_tag(:div, Account.human_attribute_name(:saving_letter),  class: "label label-primary")
      when :cash_account    then return content_tag(:div, Account.human_attribute_name(:cash_letter),    class: "label label-default")
    end
  end

  def badge_for_transaction_type transaction_type
    case transaction_type.to_sym
      when :in  then return content_tag(:div, class:"label label-success") do concat(content_tag(:i, "", class: "fa fa-arrow-up"))   end
      when :out then return content_tag(:div, class:"label label-danger")  do concat(content_tag(:i, "", class: "fa fa-arrow-down")) end
    end
  end
end

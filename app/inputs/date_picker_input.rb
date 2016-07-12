class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    template.content_tag(:div, class: 'input-group date') do
      template.concat span_table
      template.concat @builder.date_field(attribute_name, input_html_options)
    end
  end

  def input_html_options
    super.merge({class: 'form-control'})
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_table
    end
  end

  def icon_table
    "<span class=\"fa fa-calendar\"></span>".html_safe
  end
end

class MaskCurrencyValueInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('mask').push('currency_value')
  end
end

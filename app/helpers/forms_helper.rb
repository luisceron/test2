module FormsHelper
  def not_editable_for(object, attribute, form, options={})
    render partial: 'shared/attribute_not_editable', locals: {object: object, attribute: attribute, f: form, options: options}
  end
end

module FormsHelper
  def not_editable_for(object, attribute, form)
    render partial: 'shared/attribute_not_editable', locals: {object: object, attribute: attribute, f: form}
  end
end

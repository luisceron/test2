module ShowsHelper
  def show_for object, attribute, options = {}
    render partial: 'shared/show_attribute', locals: {object: object, attribute: attribute, options: options}
  end
end

module PartialsHelper
  def index_footer(object)
    render partial: 'shared/index_footer', locals: {object: object}
  end
end

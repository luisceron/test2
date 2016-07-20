module BaseController
  def index_object(classe, params)
    @query = classe.search(params[:q])
    @query.result.paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def save_object(object, options = {})
    respond_to do |format|
      if object.persisted?
        responder format, object, 'updated', options[:path], options[:fem]
      else
        responder format, object, 'created', options[:path], options[:fem]
      end
    end
  end

  def destroy_object(object, path, options = {})
    fem = options[:fem]
    object.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: t( fem ? 'controller.destroyed_fem' : 'controller.destroyed', model: object.class.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    def responder(format, object, action, path = nil, fem = nil)
      created   = action == 'created'
      status    = created ? :created : :ok
      render_to = created ? :new : :edit
      redirect  = path ? path : object

      if object.save
        format.html { redirect_to redirect, notice: t( fem ? 'controller.'+action+'_fem' : 'controller.'+action, model: object.class.model_name.human) }
        format.json { render :show, status: status, location: object }
      else
        format.html { render render_to }
        format.json { render json: object.errors, status: :unprocessable_entity }
      end
    end
end

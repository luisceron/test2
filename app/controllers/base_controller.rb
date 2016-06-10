module BaseController
  def index_object classe, params
    @query = classe.search(params[:q])
    @query.result.paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def save_object object
    respond_to do |format|
      if object.persisted?
        if object.save
          format.html { redirect_to object, notice: t('controller.updated', model: object.class.model_name.human) }
          format.json { render :show, status: :ok, location: object }
        else
          format.html { render :edit }
          format.json { render json: object.errors, status: :unprocessable_entity }
        end
      else
        if object.save
          format.html { redirect_to object, notice: t('controller.created', model: object.class.model_name.human) }
          format.json { render :show, status: :created, location: object }
        else
          format.html { render :new }
          format.json { render json: object.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy_object object, path
    object.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: t('controller.destroyed', model: object.class.model_name.human) }
      format.json { head :no_content }
    end
  end
end

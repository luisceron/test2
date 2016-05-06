module ActionsHelper
  def action_index model
    t('action.index', model: model.model_name.human.pluralize)
  end

  def action_new model
    t('action.new', model: model.model_name.human)
  end

  def action_edit model
    t('action.edit', model: model.model_name.human)
  end
end

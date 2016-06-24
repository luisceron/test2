module EnumsHelper
  def options_for_enum(model, enum)
    model.send(enum).keys.collect{ |t| [enum_translation(model, enum, t), t] }
  end

  private
    def enum_translation(model, enum, value)
      if value
        I18n.t(value, scope: "activerecord.attributes.#{model.to_s.underscore}.#{enum}")
      end
    end
end

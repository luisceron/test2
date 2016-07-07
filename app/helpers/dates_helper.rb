module DatesHelper
  def date_for attribute, format
    l attribute, format: format
  end

  def date_for attribute
    attribute.strftime("%d/%m/%Y")
  end
end

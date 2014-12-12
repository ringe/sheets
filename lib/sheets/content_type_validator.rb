class ContentTypeValidator < ActiveModel::Validator

  def content_types
    ["string","numeric","date","checkbox"] + selector_types
  end

  def selector_types
    ["select","dropdown","autocomplete"]
  end

  def validate(record)

    if record.class == Column
      unless content_types.include?(record.content_type)
        record.errors[:content_type] << "#{record.content_type} is not a valid content type"
      end

      if selector_types.include?(record.content_type)
        unless record.selector.class == Class
          record.errors[:selector_class] << "selector_class must be valid a Class name"
        end

        unless selector.methods.include?(record.selector_method)
          record.errors[:selector_method] << "selector_method must be a valid method for #{selector}"
        end

        unless record.selections.class == Array
          record.errors[:selector_method] << "selector_method must return an Array"
        end
      end
    end

  end
end

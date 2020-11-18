# frozen_string_literal: true

def build_column(name: nil, type: :boolean)
  ActiveRecord::ConnectionAdapters::Column.new(
    name || "my_#{type}",
    false,
    ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: sql_type(type))
  )
end

def build_dirty_attribute(name: nil, dirty_model: nil, type: :boolean)
  DirtySeed::DirtyAttribute.new(
    dirty_model || build_dirty_model,
    build_column(name: name, type: type)
  )
end

def build_dirty_model(model: Alfa)
  DirtySeed::DirtyModel.new(model)
end

private

def sql_type(type)
  case type
  when :float then :decimal
  when :time then :datetime
  else type
  end
end

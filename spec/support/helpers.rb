# frozen_string_literal: true

def build_column(name: nil, type: :boolean)
  ActiveRecord::ConnectionAdapters::Column.new(
    name || "my_#{type}",
    false,
    ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(type: sql_type(type))
  )
end

def build_attribute(name: nil, model: nil, type: :boolean)
  DirtySeed::Attribute.new(
    model || build_model,
    build_column(name: name, type: type)
  )
end

def build_model(model: Alfa)
  DirtySeed::Model.new(model)
end

private

def sql_type(type)
  case type
  when :float then :decimal
  when :time then :datetime
  else type
  end
end

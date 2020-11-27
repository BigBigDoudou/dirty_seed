# frozen_string_literal: true

def build_model(model)
  DirtySeed::Model.new(model)
end

def build_attribute(type, name = 'fake')
  DirtySeed::Attribute.new(
    build_column(type, name)
  )
end

def build_column(type, name = 'fake')
  ActiveRecord::ConnectionAdapters::Column.new(
    name,
    false,
    ActiveRecord::ConnectionAdapters::SqlTypeMetadata.new(
      type: sql_type(type)
    )
  )
end

private

def sql_type(type)
  case type
  when :float then :decimal
  when :time then :datetime
  else type
  end
end

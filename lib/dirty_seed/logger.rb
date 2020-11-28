# frozen_string_literal: true

# rubocop:disable Rails/Output
module DirtySeed
  # Represents an Active Record model
  class Logger
    include Singleton

    attr_accessor :verbose

    # Outputs before seeding a model
    # @param model [DirtySeed::Model]
    # @return [void]
    def seed_model_message(model)
      return unless verbose

      puts('')
      puts("Seeding #{model.name.underscore.pluralize}")
      print('> ')
    end

    # Cleans the message before output (remove linebreak and truncate)
    # @param message [String]
    # @return string
    def clean(message)
      base = message.tr("\n", "\t")
      # #truncate is defined in ActiveSupport and then could be undefined
      base.respond_to?(:truncate) ? base.truncate(150) : base.slice(150)
    end

    # Outputs a success message
    # @return [void]
    def success
      verbose && print("\e[32m.\e[0m")
    end

    # Outputs a fail message
    # @return [void]
    def failure
      verbose && print("\e[31mx\e[0m")
    end

    # Outputs an abort message
    # @return [void]
    def abort
      verbose && print("\e[31m | too many errors -> abort\e[0m")
    end

    # Outputs seeder data
    # @return [void]
    def summary(seeders)
      return unless verbose

      puts ''
      seeders.each do |seeder|
        puts seeder.model.name
        puts "  \e[32mseeded: #{seeder.records.count}\e[0m"
        puts "  \e[31merrors: #{seeder.errors.join(', ')}\e[0m" if seeder.errors.any?
      end
    end
  end
end
# rubocop:enable Rails/Output

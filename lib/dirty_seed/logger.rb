# frozen_string_literal: true

# rubocop:disable Rails/Output
module DirtySeed
  # Represents an Active Record model
  class Logger
    include Singleton

    # Sets verbose to true
    # @return [void]
    def verbose!
      @verbose = true
    end

    # Outputs before seeding a model
    # @param model [DirtySeed::Model]
    # @return [void]
    def seed(model)
      verbose && puts("Seeding #{model.name.underscore.pluralize}")
    end

    # Outputs the start of a new line
    # @return [void]
    def start_line
      verbose && print('> ')
    end

    # Outputs a success message
    # @return [void]
    def success
      verbose && print("\e[#{green}m.\e[0m")
    end

    # Outputs a fail message
    # @return [void]
    def fail
      verbose && print("\e[#{red}mx\e[0m")
    end

    # Outputs an error message
    # @return [void]
    def error
      verbose && print("\e[#{red}m!\e[0m")
    end

    # Outputs a line break
    # @return [void]
    def break_line
      verbose && puts('')
    end

    # Outputs seeder data
    # @return [void]
    def seeder_data(seeder)
      return unless verbose

      puts seeder.model.name
      puts "  \e[#{green}mseeded: #{seeder.score}\e[0m"
      puts "  \e[#{red}merrors: #{seeder.error_list}\e[0m" if seeder.errors.any?
    end

    private

    attr_reader :verbose

    # Returns color code for green
    # @return [Integer]
    def green
      32
    end

    # Returns color code for red
    # @return [Integer]
    def red
      31
    end
  end
end
# rubocop:enable Rails/Output

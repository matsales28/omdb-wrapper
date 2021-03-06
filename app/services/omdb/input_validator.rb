module Omdb
  class InputValidator
    class InputException < StandardError; end
    attr_accessor :input

    def initialize(input = {})
      @input = input
    end

    def validate_title_or_id
      return input if input.key?(:title) || input.key?(:id)

      raise InputException.new('Need to provide at least title or id as param')
    end

    def validate_multiple_search
      return input if input.key?(:title)

      raise InputException.new('Need to provide title as param for multiple searching')
    end
  end
end

require 'test_helper'

module Omdb
  class InputValidatorTest < ActiveSupport::TestCase
    test '#validate_title_or_id input to be valid need to has at least title or id as keys' do
      validator = InputValidator.new
      assert_raises InputValidator::InputException, 'Need to provide at least title or id as param' do
        validator.validate_title_or_id
      end
    end

    test '#validate_title_or_id given a valid input, should return it' do
      input = {id: 'tt1130884'}
      validator = InputValidator.new(input)
      assert_equal input, validator.validate_title_or_id
    end

    test '#validate_multiple_search input to be valid need to has title key' do
      validator = InputValidator.new
      assert_raises InputValidator::InputException, 'Need to provide title as param for multiple searching' do
        validator.validate_multiple_search
      end
    end

    test '#validate_multiple_search given a valid input, should return it' do
      input = {title: 'tt1130884'}
      validator = InputValidator.new(input)
      assert_equal input, validator.validate_multiple_search
    end
  end
end

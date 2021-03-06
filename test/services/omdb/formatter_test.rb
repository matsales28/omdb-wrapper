require 'test_helper'
module Omdb
  class FormatterTest < ActiveSupport::TestCase
    test '::by_id return input formatted for making calls to OMDb API' do
      input = {id: '1'}
      output = {i: '1'}
      assert_equal output, Omdb::Formatter.by_id(input)

      wrong_input = {title: 'Star Wars'}
      assert_raises StandardError, 'Please pass an id as param' do
        assert_equal output, Omdb::Formatter.by_id(wrong_input)
      end
    end

    test '::by_id return input formatted removing trailing whitespaces' do
      input = {id: ' tt1130884  '}
      output = {i: 'tt1130884'}
      assert_equal output, Omdb::Formatter.by_id(input)
    end

    test '::pretify_output better format for omdb output if successfull everything' do
      output = JSON.parse(json_response('omdb_response')).with_indifferent_access
      output_formatted = {movie: {
        id: 'tt1130884',
        title: 'Shutter Island',
        genre: 'Mystery, Thriller',
        year: '2010',
        director: 'Martin Scorsese',
        type: 'movie'
      }}
      assert_not_equal output_formatted, output
      assert_equal output_formatted, Omdb::Formatter.prettify_output(output)
    end

    test '::pretify_output in case a hash with error key is passed should just return the hash' do
      output = {}
      assert_not_equal output, Omdb::Formatter.prettify_output(output)

      output = {Error: 'Movie not found'}
      assert_equal({error: 'Movie not found'}, Omdb::Formatter.prettify_output(output))
    end

    test '::by_title return input formatted for making calls to OMDb API' do
      input = {title: 'Shutter Island', type: 'movies'}
      output = {t: 'Shutter Island', type: 'movies'}
      assert_equal output, Omdb::Formatter.by_title(input)

      wrong_input = {id: 'tt1130884'}
      assert_raises StandardError, 'Please pass an title as param' do
        assert_equal output, Omdb::Formatter.by_title(wrong_input)
      end
    end

    test '::by_title return input formatted removing trailing whitespaces' do
      input = {title: ' Shutter Island  ', type: ' movies'}
      output = {t: 'Shutter Island', type: 'movies'}
      assert_equal output, Omdb::Formatter.by_title(input)
    end

    test '::by_multiple_search return input formatted for making calls to OMDb API' do
      input = {title: 'Shutter Island', type: 'movies ', year: ' 1995'}
      output = {s: 'Shutter Island', type: 'movies', y: '1995'}
      assert_equal output, Omdb::Formatter.by_multiple_search(input)
    end
  end
end

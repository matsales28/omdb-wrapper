require 'test_helper'

module Omdb
  class HandlerTest < ActiveSupport::TestCase
    def setup
      @shutter_island_response = [{movie: {id: 'tt1130884', title: 'Shutter Island', genre: 'Mystery, Thriller', year: '2010', director: 'Martin Scorsese', type: 'movie'}}, :ok]
      api_key = ENV['OMDB_API_KEY']
      omdb_mock = json_response('omdb_response')
      movie_not_found_response = {"Response": 'False', "Error": 'Movie not found!'}.to_json
      request_stubber([
        {
          url: /.fake-api-key./,
          http_status: 401,
          body: {"Response": 'False', "Error": 'Invalid API key!'}.to_json
        },
        {
          url: "https://www.omdbapi.com/?apikey=#{api_key}&i=t000000022",
          http_status: 200,
          body: {"Response": 'False', "Error": 'Incorrect IMDb ID.'}.to_json
        },
        {
          url: "https://www.omdbapi.com/?apikey=#{api_key}&i=tt1130884",
          http_status: 200,
          body: omdb_mock
        },
        {
          url: "https://www.omdbapi.com/?apikey=#{api_key}&t=Not%20existent&type",
          http_status: 200,
          body: movie_not_found_response
        },
        {
          url: "https://www.omdbapi.com/?apikey=#{api_key}&s=Not%20existent&type&y",
          http_status: 200,
          body: movie_not_found_response
        },
        {
          url: "https://www.omdbapi.com/?apikey=#{api_key}&t=Shutter%20Island&type",
          http_status: 200,
          body: omdb_mock
        },
        {
          url: "https://www.omdbapi.com/?apikey=#{api_key}&s=Island&type&y",
          hhtp_status: 200,
          body: json_response('omdb_multiple_search_response')
        }])
    end

    test '::by_id when invalid params given should rescue' do
      assert_equal [{error: 'Need to provide at least title or id as param'}, :bad_request], Omdb::Handler.by_id({})
    end

    test '::by_id when passing valid params but no id' do
      assert_equal [{error: 'Please pass an id as param'}, :bad_request], Omdb::Handler.by_id({title: 'Shutter Island'})
    end

    test '::by_id when giving an wrong not supported anymore apikey' do
      ENV.stub(:[], 'fake-api-key') do
        assert_equal [{error: 'Invalid API key!'}, 401], Omdb::Handler.by_id({id: 't0000000'})
      end
    end

    test '::by_id when giving an wrong id' do
      assert_equal [{error: 'Incorrect IMDb ID.'}, :ok], Omdb::Handler.by_id({id: 't000000022'})
    end

    test '::by_id when every step of the flow is succesfull' do
      assert_equal @shutter_island_response, Omdb::Handler.by_id({id: 'tt1130884'})
    end

    test '::by_title when invalid params given should rescue' do
      assert_equal [{error: 'Need to provide at least title or id as param'}, :bad_request], Omdb::Handler.by_title({})
    end

    test '::by_title when passing valid params but no id' do
      assert_equal [{error: 'Please pass an title as param'}, :bad_request], Omdb::Handler.by_title({id: 'tt1130884'})
    end

    test '::by_title when giving an wrong not supported anymore apikey' do
      ENV.stub(:[], 'fake-api-key') do
        assert_equal [{error: 'Invalid API key!'}, 401], Omdb::Handler.by_title({title: 'Shutter Island'})
      end
    end

    test '::by_title when giving an not found title' do
      assert_equal [{error: 'Movie not found!'}, :ok], Omdb::Handler.by_title({title: 'Not existent'})
    end

    test '::by_title when every step of the flow is succesfull' do
      assert_equal @shutter_island_response, Omdb::Handler.by_title({title: 'Shutter Island'})
    end

    test '::multiple_search when invalid params given should rescue' do
      assert_equal [{error: 'Need to provide title as param for multiple searching'}, :bad_request], Omdb::Handler.multiple_search({})
    end

    test '::multiple_search when giving an wrong not supported anymore apikey' do
      ENV.stub(:[], 'fake-api-key') do
        assert_equal [{error: 'Invalid API key!'}, 401], Omdb::Handler.multiple_search({title: 'Shutter Island'})
      end
    end

    test '::multiple_search when giving an not found title' do
      assert_equal [{error: 'Movie not found!'}, :ok], Omdb::Handler.multiple_search({title: 'Not existent'})
    end

    test '::multiple_search when every step of the flow is succesfull' do
      assert_equal [{movies: [{movie: {id: 'tt1130884', title: 'Shutter Island', year: '2010', type: 'movie'}}, {movie: {id: 'tt0399201', title: 'The Island', year: '2005', type: 'movie'}}, {movie: {id: 'tt3731562', title: 'Kong: Skull Island', year: '2017', type: 'movie'}}, {movie: {id: 'tt1397514', title: 'Journey 2: The Mysterious Island', year: '2012', type: 'movie'}}, {movie: {id: 'tt0287717', title: 'Spy Kids 2: Island of Lost Dreams', year: '2002', type: 'movie'}}, {movie: {id: 'tt0410377', title: "Nim's Island", year: '2008', type: 'movie'}}, {movie: {id: 'tt0983946', title: 'Fantasy Island', year: '2020', type: 'movie'}}, {movie: {id: 'tt0116654', title: 'The Island of Dr. Moreau', year: '1996', type: 'movie'}}, {movie: {id: 'tt1174730', title: 'City Island', year: '2009', type: 'movie'}}, {movie: {id: 'tt9686708', title: 'The King of Staten Island', year: '2020', type: 'movie'}}]}, :ok], Omdb::Handler.multiple_search({title: 'Island'})
    end
  end
end

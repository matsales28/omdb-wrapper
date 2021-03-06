require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  def setup
    api_key = ENV['OMDB_API_KEY']
    omdb_mock = json_response('omdb_response')
    request_stubber([
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

  test '#search_by_id return json with a specific movie query on OMDB by id' do
    get api_v1_movie_path('tt1130884')
    assert_response :success
    assert_equal({'movie'=>{'id'=>'tt1130884', 'title'=>'Shutter Island', 'genre'=>'Mystery, Thriller', 'year'=>'2010', 'director'=>'Martin Scorsese', 'type'=>'movie'}}, JSON.parse(response.body))
  end

  test '#search_by_title return json with a specific movie query on OMDB by title' do
    get api_v1_movies_path, params: {title: 'Shutter Island'}
    assert_response :success
    assert_equal({'movie'=>{'id'=>'tt1130884', 'title'=>'Shutter Island', 'genre'=>'Mystery, Thriller', 'year'=>'2010', 'director'=>'Martin Scorsese', 'type'=>'movie'}}, JSON.parse(response.body))
  end

  test '#multiple_search return json with a movies with a similar title' do
    get api_v1_search_path, params: {title: 'Island'}
    assert_response :success
    assert_equal({'movies'=>[{'movie'=>{'id'=>'tt1130884', 'title'=>'Shutter Island', 'year'=>'2010', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt0399201', 'title'=>'The Island', 'year'=>'2005', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt3731562', 'title'=>'Kong: Skull Island', 'year'=>'2017', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt1397514', 'title'=>'Journey 2: The Mysterious Island', 'year'=>'2012', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt0287717', 'title'=>'Spy Kids 2: Island of Lost Dreams', 'year'=>'2002', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt0410377', 'title'=>"Nim's Island", 'year'=>'2008', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt0983946', 'title'=>'Fantasy Island', 'year'=>'2020', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt0116654', 'title'=>'The Island of Dr. Moreau', 'year'=>'1996', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt1174730', 'title'=>'City Island', 'year'=>'2009', 'type'=>'movie'}}, {'movie'=>{'id'=>'tt9686708', 'title'=>'The King of Staten Island', 'year'=>'2020', 'type'=>'movie'}}]}, JSON.parse(response.body))
  end
end

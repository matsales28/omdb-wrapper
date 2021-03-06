# OMDB Wrapper

A Ruby on Rails API that encapsulates the OMbd API search service.

# What can my project do?

I create an API REST that encapsulates OMDb API, making it a little more clear how to pass params and what they really are.

I've been studying gem u-case [u-case](https://github.com/serradura/u-case) and from the way it worked I had the idea of ​​doing something similar, in a more simplified way. There is a handler that basically encapsulates the entire flow (validation, formatting, request, formatting)

This is good, because every step of the flow can be tested isolated and you can also test the entire flow, and every step obbeys SRP.

This application was deployed to [Heroku](https://matheus-sales.herokuapp.com) and has an monitoring application you can check it on https://www.rorvswild.com/applications/1148/, I have sent you a invite to your e-mail to join rorvswild, any trouble on checking it you can message me.

The project is 100% covered by tests, you can get more details of this at /coverage route and has a score of 94.91 at Rubycritic, you can check this by running
`$ rubycritic`

# Dependencies

## Ruby version

2.6.5p114

## Rails version

Rails 6.0.3.4

# How to use it

1. Clone the repository

```
   $ git clone https://github.com/Instituto-Atlantico/matheus-sales.git
```

2. Running with Docker(jump to step 5 if not using docker)

```
   $ docker-compose build
```

3. Starting the server

```
   $ docker-compose up
```

4. Running tests

```
   $ docker-compose run -e "RAILS_ENV=test" web rake test
```

5. Running without docker

```
   $ bundle install
```

6. Run the local server

```
   $ rails s
```

7. For running tests

```
   $ rake test
```

# Documentation

This API consists of three endpoints they're all explained on [this](https://documenter.getpostman.com/view/13586792/TVev55CM) Postman Documentation

### API Resources

- [GET /api/v1/movies/[id]](#get-moviesid)
- [GET /api/v1/movies?[title]](#get-moviestitle)
- [GET /api/v1/search?{title,year,type}](#get-moviessearch)

### GET /api/v1/movies/[id]

Example: https://matheus-sales.herokuapp.com/api/v1/movies/tt1130884.json
In this endpoint the path param id is required.
Response body:

```json
{
  "movie": {
    "id": "tt1130884",
    "title": "Shutter Island",
    "genre": "Mystery, Thriller",
    "year": "2010",
    "director": "Martin Scorsese",
    "type": "movie"
  }
}
```

### GET /api/v1/movies?[title]

Example: https://matheus-sales.herokuapp.com/api/v1/movies?title=Island.json
In this endpoint the query param title is required.
Response body:

```json
{
  "movie": {
    "id": "tt1130884",
    "title": "Shutter Island",
    "genre": "Mystery, Thriller",
    "year": "2010",
    "director": "Martin Scorsese",
    "type": "movie"
  }
}
```

### GET /api/v1/search?{title,year,type}

Example: https://matheus-sales.herokuapp.com/api/v1/search?title=Island&type=movie.json
In this endpoint, the param title is the only required, the others are optional.

Response body:

```json
{
  "movies": [
    {
      "movie": {
        "id": "tt1130884",
        "title": "Shutter Island",
        "year": "2010",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt0399201",
        "title": "The Island",
        "year": "2005",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt3731562",
        "title": "Kong: Skull Island",
        "year": "2017",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt1397514",
        "title": "Journey 2: The Mysterious Island",
        "year": "2012",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt0287717",
        "title": "Spy Kids 2: Island of Lost Dreams",
        "year": "2002",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt0410377",
        "title": "Nim's Island",
        "year": "2008",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt0983946",
        "title": "Fantasy Island",
        "year": "2020",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt0116654",
        "title": "The Island of Dr. Moreau",
        "year": "1996",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt1174730",
        "title": "City Island",
        "year": "2009",
        "type": "movie"
      }
    },
    {
      "movie": {
        "id": "tt9686708",
        "title": "The King of Staten Island",
        "year": "2020",
        "type": "movie"
      }
    }
  ]
}
```

# To improve

1. Implement a kind of cache, saving the results of requests in a database, making sure that new requests for that same film do not need to hit the OMDb service.
2. Making a CI / CD for the application, for the sake of time I was unable to study a simple way to do it on GitHub. I even thought about making a pipeline in GitLab that I already have experience in making but I thought it was not so necessary. But it is a point that I will certainly study from the outside, to expand my knowledged.
3. Because it is somewhat of an external api wrapper it was not a priority for me to implement a performance control tool like NewRelic or Scout, but it would be a point of improvement in the project.
4. The Handler file contains a repetition of code, with metaprogramming into a single way to declare flow but I think that with that the understanding of flows and how they are assembled would be impaired, a code being complicated to understand to be succinct is a tradeoff that may not be advantageous. But that would be a point of improvement, making the flow with less repetitions and as simple as possible

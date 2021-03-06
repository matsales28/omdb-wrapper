module Omdb
  class Handler
    def self.by_id(params)
      params.then { |input| InputValidator.new(input).validate_title_or_id }
            .then { |input| Formatter.by_id(input) }
            .then { |formatted_input| RequestMaker.new(formatted_input).perform_request }
            .then { |movie| Formatter.prettify_output(movie) }
            .then { |movie_formatted| [movie_formatted, :ok] }
    rescue RestClient::ExceptionWithResponse => error
      rest_client_error_handler(error, params)
    rescue StandardError => error
      handle_error(error, error.message, params)
    end

    def self.by_title(params)
      params.then { |input| InputValidator.new(input).validate_title_or_id }
            .then { |input| Formatter.by_title(input) }
            .then { |formatted_input| RequestMaker.new(formatted_input).perform_request }
            .then { |movie| Formatter.prettify_output(movie) }
            .then { |movie_formatted| [movie_formatted, :ok] }
    rescue RestClient::ExceptionWithResponse => error
      rest_client_error_handler(error, params)
    rescue StandardError => error
      handle_error(error, error.message, params)
    end

    def self.multiple_search(params)
      params.then { |input| InputValidator.new(input).validate_multiple_search }
            .then { |input| Formatter.by_multiple_search(input) }
            .then { |formatted_input| RequestMaker.new(formatted_input).perform_request }
            .then { |data| Formatter.multiple_search_output(data) }
            .then { |output_formatted| [output_formatted, :ok] }
    rescue RestClient::ExceptionWithResponse => error
      rest_client_error_handler(error, params)
    rescue StandardError => error
      handle_error(error, error.message, params)
    end

    private
      def self.rest_client_error_handler(error, params)
        response = error.response
        status = response.code
        error_message = JSON.parse(response.body)['Error']
        handle_error(error, error_message, params, status)
      end

      def self.handle_error(error, message, params, status = :bad_request)
        RorVsWild.record_error(
          error,
          {
            error: message,
            params: params
          }
        )
        [{error: message}, status]
      end
  end
end

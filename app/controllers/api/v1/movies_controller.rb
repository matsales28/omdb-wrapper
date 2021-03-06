module Api
  module V1
    class MoviesController < ApplicationController
      def search_by_id
        response, status = Omdb::Handler.by_id(permitted_params)
        json_response(response, status)
      end

      def search_by_title
        response, status = Omdb::Handler.by_title(permitted_params)
        json_response(response, status)
      end

      def multiple_search
        response, status = Omdb::Handler.multiple_search(permitted_params)
        json_response(response, status)
      end

      private
        def permitted_params
          params.permit(:title, :id, :type, :year)
        end
    end
  end
end

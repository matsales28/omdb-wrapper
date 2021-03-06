module Omdb
  class Formatter
    class << self
      def by_id(input)
        raise StandardError.new('Please pass an id as param') unless input.key?(:id)
        {
          i: input[:id].strip
        }
      end

      def by_title(input)
        raise StandardError.new('Please pass an title as param') unless input.key?(:title)
        {
          t: input[:title].strip,
          type: input[:type]&.strip
        }
      end

      def by_multiple_search(input)
        {
          s: input[:title].strip,
          type: input[:type]&.strip,
          y: input[:year]&.strip
        }
      end

      def multiple_search_output(output)
        output.deep_transform_keys!(&:downcase)
        return {error: output[:error]} if output.key?(:error)

        {movies: output[:search].map { |movie| prettify_output(movie) }}
      end

      def prettify_output(output)
        output.transform_keys!(&:downcase)
        return {error: output[:error]} if output.key?(:error)

        {
          movie: {
          id: output[:imdbid],
          title: output[:title],
          genre: output[:genre],
          year: output[:year],
          director: output[:director],
          type: output[:type]
          }.compact
      }
      end
    end
  end
end

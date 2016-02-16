module CustomFoursquare
  class APIError < StandardError

    attr_reader :code
    attr_reader :detail
    attr_reader :type
    attr_reader :response

    def initialize(error, response)
      @code   = error.code
      @detail = error.errorDetail
      @type   = error.errorType
      @response = response
    end

    def message
      #"#{@type}: #{@detail} (#{@code})"
      "#{@type}: #{@detail} (#{@code}) (#{@response}"
    end
    alias :to_s :message
  end
end

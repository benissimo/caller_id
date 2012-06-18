require "caller_id/version"
require "json"
require "open-uri"

module CallerId
  # This class leverages the OpenCNAM service to lookup names from phone numbers.
  # http://docs.opencnam.com/guide.html
  class ReversePhoneLookup
    def initialize number, user = nil, key = nil
      @phone_number = number.to_s.gsub(/\D/,'').gsub(/\A1/,'') # strip spaces, punctuation, and leading 1s.
      # TODO: consider raising a specific Exception here.
      raise "invalid format" if @phone_number.nil? || @phone_number.strip.empty? || @phone_number.length != 10
      if user && key
        @api_user = user
        @api_key  = key
      end
    end
    # Derived from https://github.com/EricR/sinatra-cnam-lookup/blob/master/cnam_checker.rb
    def lookup
      begin
        response = open(get_url)
      rescue OpenURI::HTTPError
        return {:not_found => true}
      end
      return {:retry => true, :now => Time.now} if response.status[0] == "202"
      return if response.status[0] != "200"
      json_response = response.read
      results = JSON.parse(json_response)
      {:cnam => results["cnam"].strip, :number => results["number"]}
    end
    private
    def get_url
      url = "https://api.opencnam.com/v1/phone/#{@phone_number}?format=json"
      url += "&username=#{@api_user}&api_key=#{@api_key}" if @api_user && @api_key
      url
    end
  end
end

require 'httparty'

# module LoginHelper
#   include HTTParty
#   base_uri ENV['API_IoT']  # Use the environment variable for the base URL

  
#   def self.req_post(url_path, data)
#     begin
#       response = post(url_path, body: data, verify: false)
      
#       # Handle HTTParty response
#       if response.success?
#         return response.parsed_response
#       else
#         # Handle non-successful response (e.g., error handling)
#         # You can raise an exception, log the error, or return an appropriate response.
#         # For example:
#         # raise StandardError.new("Request failed with status #{response.code}: #{response.body}")
#         # or
#         # return { error: "Request failed with status #{response.code}" }
#       end
#     rescue StandardError => e
#       # Handle exceptions (e.g., network errors)
#       # You can raise a custom exception or log the error.
#       # For example:
#       # raise CustomException.new("An error occurred: #{e.message}")
#       # or
#       # Rails.logger.error("An error occurred: #{e.message}")
#       # or
#       # return { error: "An error occurred: #{e.message}" }
#     end
#   end
# end
module LoginHelper
    def self.req_post(url_path,data)
        url = ENV['API_IoT']+url_path
        res = HTTParty.post(url,
            :body => data,
            verify: false
        )
        return res.parsed_response
    end
end
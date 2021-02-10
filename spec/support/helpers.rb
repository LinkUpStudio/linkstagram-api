module Helpers
  module JwtToken
    def jwt_token(id)
      rodauth = Rodauth::Rails.rodauth
      token = JWT.encode({ account_id: id }, rodauth.jwt_secret, rodauth.jwt_algorithm)
      "Bearer #{token}"
    end
  end

  module JsonParse
    def parsed_json
      JSON.parse(response_body)
    end
  end
end

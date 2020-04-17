class UserController < ApplicationController

  # curl "https://sandbox.xfers.io/api/v3/authorize/signup_login"\
  # -H "X-XFERS-APP-API-KEY: yyyMATdkKiv2s9ZQVQ-C1x2RY4xF928xnrUagfQwXaQ"\
  # -H "Content-Type: application/json" \
  # -d '{"phone_no" : "+6597288608", "signature" : "178502abfa891b69a9a2f72192d51f5fc141f978"}'
  def generate_otp
    phone_number = "+6584700012"current_user.phone_number
    request_params = {
      phone_no: phone_number,
      signature: Digest::SHA1.hexdigest("#{phone_number}#{X_XFERS_APP_SECRET_KEY}")
    }
    response = HTTParty.post(XFERS_SIGNUP_URL, {
      headers: {"X-XFERS-APP-API-KEY" => X_XFERS_APP_API_KEY},
      body: request_params
    })

    result = response.parsed_response

    if result['msg'] == "success"
      render json: result, status: ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  #request
  # curl "https://sandbox.xfers.io/api/v3/authorize/get_token?otp=541231&phone_no=%2B6597288608&signature=bdc26373b3a78dd11dc840a1b7973f197cf34c91" \
  # -H "X-XFERS-APP-API-KEY: yyyMATdkKiv2s9ZQVQ-C1x2RY4xF928xnrUagfQwXaQ"
  # {String} phone_no - [REQUIRED] User mobile no
  # {String} otp - [REQUIRED] 6 digit one-time-password sent to users through SMS
  # {String} signature - [REQUIRED] SHA1-hex of (phone_no + OTP + APP_SECRET_KEY)
  def verify_otp
    otp = params[:otp]
    phone_number = current_user.phone_number

    request_params = {
      phone_no: phone_number,
      otp: otp,
      signature: Digest::SHA1.hexdigest("#{phone_number}#{otp}#{X_XFERS_APP_SECRET_KEY}")
    }

    response = HTTParty.get(XFERS_GET_TOKEN_URL, {
      headers: {"X-XFERS-APP-API-KEY" => X_XFERS_APP_API_KEY},
      body: request_params
    })

    result = response.parsed_response

    if result['msg'] == "success"
      current_user.update_columns(xfers_api_token: result['user_api_token'])
      result.delete('user_api_token')
      render json: result, status: ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  def info

    # 'GET/v3/user/activities'

    render json: @current_user, status: ok
  end

end

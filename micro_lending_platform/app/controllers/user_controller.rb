class UserController < ApplicationController



  # curl "https://sandbox.xfers.io/api/v3/authorize/signup_login"\
  # -H "X-XFERS-APP-API-KEY: yyyMATdkKiv2s9ZQVQ-C1x2RY4xF928xnrUagfQwXaQ"\
  # -H "Content-Type: application/json" \
  # -d '{"phone_no" : "+6597288608", "signature" : "178502abfa891b69a9a2f72192d51f5fc141f978"}'
  def generate_otp
    phone_number = current_user.phone_number
    phone_number = "+6586895505"
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
    # otp = params[:otp]
    otp = 313541
    # phone_number = current_user.phone_number
    phone_number = "+6586895505"

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
    phone_number = "+6587533569"
    response = HTTParty.get(XFERS_GET_TRANSACTION_HISTORY_URL, {
      headers: {"X-XFERS-APP-API-KEY" => X_XFERS_APP_API_KEY},
    })

    result = {
      transaction_history: response.parsed_response,
      my_loans: Loan.where(requester_id: current_user.id).all.collect{|l| l.to_json}
    }
    render json: result, status: ok
  end

  def invest_in_loan
    phone_number = "+6587533569"

    # charge_params = {
    #   amount: params[:amount],
    #   order_id: "loan_#{params[:loan_id]}_user_#{current_user.id}",
    #   description: "Testing for Documentation",
    #   notify_url: "https://www.example.com/updates",
    #   meta_data: "test metadata"
    # }
    charge_params = {
      amount: 20,
      order_id: "loan_1",
      description: "Testing for Documentation",
      notify_url: "https://www.example.com/updates",
      meta_data: "test metadata"
    }

    # response = HTTParty.post(XFERS_CREATE_CHARGE, {
    #   headers: {"X-XFERS-USER-API-KEY" => current_user.xfers_api_token},
    #   body: charge_params
    # })

    response = HTTParty.post(XFERS_CREATE_CHARGE, {
      headers: {"X-XFERS-USER-API-KEY" => User.last.xfers_api_token},
      body: charge_params
    })

    #payout
    # curl --location --request POST "$BASE_URL/v3/payouts" \
    # --header "X-XFERS-APP-API-KEY: {{user-api-key}}" \
    # --header "Content-Type: application/json" \
    # --form "user_api_token=$CUSTOMER_API_KEY" \
    # --form "amount=15000.00" \
    # --form "invoice_id=Order_docs_123" \
    # --form "descriptions=Payment for Rent for July"

    X-XFERS-APP-API-KEY
    user-api-token

    payout_params = {
      user_api_token: User.first.xfers_api_token,
      amount: 2,
      invoice_id: "Order_docs_12345",
      description: "Testing for Documentation"
    }

    response = HTTParty.post(XFERS_PAYPOUT, {
      headers: {"X-XFERS-APP-API-KEY" => X_XFERS_APP_API_KEY},
      body: payout_params
    })
  end

end

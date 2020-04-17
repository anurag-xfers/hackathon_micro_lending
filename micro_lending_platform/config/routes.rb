Rails.application.routes.draw do
  resources :loans
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root to: "home#index"

# Requirement
# /register (POST, formdata = {fname, lname, email, password})
# /login (POST, {username, password})

# /loans (POST, {period, roi, amt, description, extra: {}})

# loan current
# 1. people asked loans -> not me loan creator


# /loans/:id (GET, {id}) -> Returns the information of a given loan
# /loans (GET, params = {limit, page}) -> Returns all available loan requests sorted by time

# /credit_score (GET) -> Returns the credit score associated with the current user
# /flag_user (POST, {user_id, reason}) -> Flags a user for particular reason, may decrease their trust score
# /invest (POST, {loan_id, amt, extra: {}}) -> Invests the amount on a particular loan.


# loan current
# 1. people asked loans -> not me loan creator

# User controller
# https://github.com/Xfers/xfers-sdk/wiki/Backend-requirements-for-SDK#loginsignup-to-xfers
post 'user/generate_otp' => 'user#generate_otp'
post 'user/verify_otp' => 'user#verify_otp'
get 'user/info' => 'user#info'

# Step 3
# This api will use https://docs.xfers.io/Singapore#tag/Charge
# create charge and payout
# post /invest/:loan_id body{amount: 10}
# transfer his asked money to loan creator


end

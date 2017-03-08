Rails.application.routes.draw do
  root "static_pages#index"

  mount Ckeditor::Engine => '/ckeditor'

  delete "join_event" => "user_events#destroy"
  get "other-clubs" => "clubs#index"

  devise_for :users, controllers: {registrations: "registrations", sessions: "authentications"}
  devise_for :admin, controllers: {sessions: "admin/sessions"}

  devise_scope :admin do
    get "/admin/sign_in" => "admin/sessions#new", as: :new_admin_sessions
    delete "/admin/sign_out" => "admin/sessions#destroy", as: :destroy_admin_sessions
  end

  namespace :admin do
    get "/" => "static_pages#index"
    resources :users
    resources :organizations, except: [:edit, :update, :destroy]
    resources :organization_requests
  end

  namespace :manager do
    get "/" => "static_pages#index"
    resources :requests
    resources :members
    resources :clubs
    resources :organizations
    resources :request_members
  end

  namespace :club_manager do
    get "/" => "static_pages#index"
    resources :clubs do
      resources :members, only: [:index, :show]
      resources :club_budgets
      resources :events do
        resources :news
      end
      resources :albums do
        resources :images
      end
      resources :user_clubs
      resources :requests
    end
    resources :budgets
  end

  resources :users do
    resources :club_requests, only: [:new, :create, :index]
    resources :organization_requests, only: [:new, :create, :index]
    resources :other_clubs, only: :index
    resources :user_organizations, except: [:new, :update]
  end

  resources :clubs, only: [:show, :index] do
    mount ActionCable.server => "/cable"
    resources :events, only: :show
  end

  resources :invite_join_clubs, only: :create
  resources :messages, only: [:new, :create, :index]
  resources :user_events, only: :create
  resources :ratings, only: :create
  resources :organizations, only: [:show, :index]
  resources :time_line_homes
  resources :time_line_homes
  resources :my_clubs
  resources :comments
  resources :set_language, only: :update
  resources :reason_leaves, only: [:index, :show, :create]
  resources :activities, only: :create
  resources :user_clubs, only: [:create, :destroy]
  resources :user_organizations, only: [:create, :destroy]
  resources :albums
end

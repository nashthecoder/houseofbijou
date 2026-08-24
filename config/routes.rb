Rails.application.routes.draw do
  root "disguise#show"

  post "/unlock", to: "unlock#create"
  post "/hide", to: "unlock#destroy"

  get "/values", to: "welcome#show"
  post "/values", to: "welcome#accept"

  get "/onboarding", to: "onboarding#show"
  post "/onboarding", to: "onboarding#create"

  get "/dashboard", to: "dashboard#show"
  get "/panic", to: "panic#show"
  post "/panic", to: "panic#create"
  get "/circle", to: "circle#show"
  post "/circle/contacts", to: "circle#create"
  get "/chat", to: "chat#index"
  get "/chat/:id", to: "chat#show", as: :chat_thread
  post "/chat/:id/messages", to: "chat#create_message", as: :chat_messages
  post "/chat/timer", to: "chat#update_timer"
  get "/aid", to: "aid#index"
  get "/aid/requests/:id", to: "aid#show", as: :aid_request
  post "/aid/requests", to: "aid#create_request"
  post "/aid/requests/:id/pledge", to: "aid#pledge", as: :aid_pledge
  get "/community", to: "community#show"
  post "/community/votes/:id/support", to: "community#support", as: :community_support
  post "/community/stories", to: "community#create_story", as: :community_stories
  get "/settings", to: "settings#show"
  patch "/settings", to: "settings#update"
  post "/settings/download_data", to: "settings#download_data", as: :download_data_settings
  post "/settings/delete_data", to: "settings#delete_data", as: :delete_data_settings
  get "/coordinator", to: "coordinator#show"
  get "/progress", to: "progress#show"
  post "/coordinator/review", to: "coordinator#review", as: :coordinator_review
  post "/coordinator/moderate", to: "coordinator#moderate", as: :coordinator_moderate
end

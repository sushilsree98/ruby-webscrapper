Rails.application.routes.draw do
  namespace :api do
    get 'get_data', action: :getData, controller: :generate
    post 'add_data', action: :addData, controller: :generate
    get 'show_scrap', action: :showScrap, controller: :generate
    put 'update_scrap', action: :updateScrap, controller: :generate
    delete 'delete_scrap', action: :deleteScrap, controller: :generate
  end
end

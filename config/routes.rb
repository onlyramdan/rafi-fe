Rails.application.routes.draw do
  # get 'login', to: 'master#login' # Gantilah 'index' dengan aksi yang sesuai


  root 'master#dashboard'
  
  # get '/signup', to: 'master#signup'
  # post '/signup', to: 'master#aksi_signup'
  get "/login", to: "login#index", as: "login"
  # get "/login" => "login#index"
  get "/aksi_signout" => "login#logout"
  post "/aksi_login" => "login#login"
  resource :login

 

  get "/signup" => "login#index"
  post "/aksi_signup" => "login#signup"
  resource :login

  get 'master/index'
  post 'master/index'

  get 'master/info'
  post 'master/info'

  get 'master/setting'
  post 'master/setting'

  get 'master/button'
  post 'master/button'

  get 'master/lux'
  post 'master/lux'

  get 'master/blank'
  post 'master/blank'

  get 'master/dashboard', to: 'master#dashboard'
  post 'master/dashboard'
  get "/mqtt/sub" =>  "master#get_data_mqtt"

  get 'master/cuaca'
  post 'master/cuaca'

  get 'master/cb'

  post '/master/aksi_login'
  get '/master/aksi_login'

  # get "login/login"

  get 'master/grafik'
  get 'master/grafiklux'


  get 'master/profileakun'
  get "master/settingdata"

  get "/setting", to: "master#tambahalat", as: "tambahalat"
  post "/aksi_simpan" => "master#simpan_alat"
  post "/aksi_hapusalat" => "master#hapus_alat"
  resource :master

  get "/user", to: "master#usersetting", as: "usersetting"
  post "/user_simpan" => "master#simpan_user"
  post "/aksi_hapususer" => "master#hapus_user"
  resource :master

  get "/report", to: "master#reportdata", as: "reportdata"
  get 'generate_pdf_report', to: 'master#generate_pdf_report', format: :pdf
  
  get 'download_pdf', to: 'master#download_pdf'

  get "/export", to: "master#download_csv" , as: "reportdatacsv"
  # get "/report/ekspor", to: "master#ekspor_reportdata", as: "ekspor_reportdata", format: 'xlsx'
  # post "/aksi_ekspor" => "master#ekspor_excel"
  
  # post "/aksi_eksport" => "master#eksport"
  # config/routes.rb
  # get '/master/usersetting', to: 'master#usersetting', as: 'usersetting'


  get "/profile" => "master#profileakun"
  post "/profile/aksi_edit" => "master#editprofile"
  resource :master
  # routes 404
  get '*unmatched_route', to: 'errors#not_found'

  

  # resources :master do
  #   post 'ekspor_excel', on: :collection
  # end
  
  # get "master/eksport"
  # resources :master do
  #   member do
  #     get 'eksport', defaults: { format: 'xlsx' }
  #   end
  # end

  # config/routes.rb
 
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
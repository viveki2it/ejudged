EJudged::Application.routes.draw do

  resources :csv_uploads


  resources :companies


  resources :event_specialities
  
  resources :results


  resources :questions


  resources :question_types


  resources :question_categories


  resources :contests


  resources :entries


  resources :judge_sheets


  resources :photos

  post "new_registration/addCar"
  post "vote/Calificate"
  get "vote/getQuestionsAndAnswers"
  get "login/login" #server
  get "login/index" #website
  get "login/home" #website
  get "login/logout" #website
  post "login/authenticate" #website
  post "specialities/freeze"

  resources :series do
    resources :events
  end

  resources :events do
    resources :contests
  end

  resources :customers do
    resources :entries
  end

  resources :contests do
    resources :entries
  end

  resources :entries do
    resources :results
  end
  
  resources :questions do
    resources :results
  end

  resources :question_categories do
    resources :questions
  end

  resources :categories do
    resources :contests
  end

  resources :judge_sheets do
    resources :contests
  end

  resources :judge_sheets do
    resources :questions
  end

  resources :users do
    resources :roles
  end

  resources :users do
    resources :results
  end

  resources :contact_infos do
    resources :customers
  end

  resources :events do
    resources :specialities
  end

  resources :entries do
    resources :photos
  end

  resources :specialities
  resources :customers
  resources :clubs
  resources :entries
  resources :roles
  resources :users 
  resources :events
  resources :users
  resources :categories
  resources :customers
  resources :entries
  resources :roles
  resources :meta_result_submissions
  resources :results
  resources :questions
  resources :final_results
  resources :billing_infos
  resources :contests
  resources :judge_sheets
  resources :judge_assignments
  resources :e_judge_settings
  resources :contact_infos
  resources :results
  resources :users
  resources :tokens
  

  root :to => 'login#home'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
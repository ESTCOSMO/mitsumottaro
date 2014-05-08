Mitsumoritaro::Application.routes.draw do
  resources :template_tasks
  resources :projects do
    member do
      post "dup" => 'projects#dup_form', as: :dup
    end
    resources :additional_costs
    resource :dashboard do
      member do
        get "convert" => 'dashboards#convert', as: :convert
      end
    end
    resources :project_tasks do
      member do
        get "move_higher" => 'project_tasks#move_higher', as: :move_higher
        get "move_lower" => 'project_tasks#move_lower', as: :move_lower
      end
    end
    resources :categories, controller: :items do
      member do
        get "move_higher" => 'items#move_higher', as: :move_higher
        get "move_lower" => 'items#move_lower', as: :move_lower
        post "copy" => 'items#copy', as: :copy
      end
      resources :sub_categories, controller: :items do
        member do
          get "move_higher" => 'items#move_higher', as: :move_higher
          get "move_lower" =>  'items#move_lower', as: :move_lower
          post "copy" => 'items#copy', as: :copy
        end
        resources :stories, controller: :items do
          member do
            get "move_higher" => 'items#move_higher', as: :move_higher
            get "move_lower" => 'items#move_lower', as: :move_lower
            post "copy" => 'items#copy', as: :copy
          end
          resources :task_points
        end
      end
    end
  end

  namespace :api do
    resources :projects do
      resources :categories do
        member do
          patch "move_higher" => 'categories#move_higher', as: :move_higher
          patch "move_lower" => 'categories#move_lower', as: :move_lower
        end
        resources :sub_categories do
          member do
            patch "move_higher" => 'sub_categories#move_higher', as: :move_higher
            patch "move_lower" => 'sub_categories#move_lower', as: :move_lower
          end
          resources :stories do
            member do
              patch "move_higher" => 'stories#move_higher', as: :move_higher
              patch "move_lower" => 'stories#move_lower', as: :move_lower
            end
            resources :task_points
          end
        end
      end
    end
  end

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
  root :to => 'projects#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

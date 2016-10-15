Rails.application.routes.draw do
  scope '/api' do
    get :comments, to: 'comments#index'
    post :comments, to: 'comments#create'
  end
end

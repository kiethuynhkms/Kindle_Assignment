Rails.application.routes.draw do
  resources :transactions
  resources :stocks
  resources :highlights
  resources :books
  resources :collections
  resources :highlights
  resources :stocks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  resources :collections
  post "login", to: "users#login"
  post "/collections/:collection_id/books", to: "users#add_book_to_collection"
  put "/books/:collection_id/:book_id/:page", to: "users#remember_last_page"
  delete "/books/collections/:collection_id", to: "users#remove_book_from_collection"
  put "books/:book_id/collections/:collection_id", to: "books#set_book_as_active"
  get "/highlights/:page/books/:book_id", to: "highlights#get_highlights_by_page_of_book"
  post "/stocks/books", to: "stocks#add_book_to_stock"
  get "/users/purchased/books", to: "users#get_purchased_books_for_user"
  get "/books/:book_id/:format", to: "books#export"
end

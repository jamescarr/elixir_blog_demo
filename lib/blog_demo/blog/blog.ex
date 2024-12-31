defmodule BlogDemo.Blog do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  json_api do
    routes do
      # in the domain `base_route` acts like a scope
      base_route "/posts", BlogDemo.Blog.Post do
        get :read, default_fields: [:title, :content]
        index :read, default_fields: [:title]
        post :create
      end
    end
  end

  resources do
    resource BlogDemo.Blog.Post do
      # Define an interface for calling resource actions.
      define :create_post, action: :create
      define :list_posts, action: :read
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end
  end
end

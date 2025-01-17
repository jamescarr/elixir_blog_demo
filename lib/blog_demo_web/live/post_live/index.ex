defmodule BlogDemoWeb.PostLive.Index do
  use BlogDemoWeb, :live_view
  require BlogDemo.Blog.Post

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Posts
      <:actions>
        <.link patch={~p"/posts/new"}>
          <.button>New Post</.button>
        </.link>
      </:actions>
    </.header>

    <p>There are {@post_count} posts.</p>
    <.table
      id="posts"
      rows={@streams.posts}
      row_click={fn {_id, post} -> JS.navigate(~p"/posts/#{post}") end}
    >
      <:col :let={{_id, post}} label="Id">{post.id}</:col>
      <:col :let={{_id, post}} label="Title">{post.title}</:col>

      <:action :let={{_id, post}}>
        <div class="sr-only">
          <.link navigate={~p"/posts/#{post}"}>Show</.link>
        </div>

        <.link patch={~p"/posts/#{post}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, post}}>
        <.link
          phx-click={JS.push("delete", value: %{id: post.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <ul>
    </ul>
    <.modal :if={@live_action in [:new, :edit]} id="post-modal" show on_cancel={JS.patch(~p"/posts")}>
      <.live_component
        module={BlogDemoWeb.PostLive.FormComponent}
        id={(@post && @post.id) || :new}
        title={@page_title}
        action={@live_action}
        post={@post}
        patch={~p"/posts"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Ash.get!(BlogDemo.Blog.Post, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, nil)
  end

  defp apply_action(socket, :index, params) do
    IO.puts("Query...")
    page_opts = %{
      page: Map.get(params, "page", "1") |> String.to_integer(),
      limit: Map.get(params, "limit", "25") |> String.to_integer()
    }

    posts =
      BlogDemo.Blog.Post
      |> Ash.Query.for_read(:read)
      |> Ash.Query.limit(page_opts.limit)
      |> Ash.Query.offset((page_opts.page - 1) * page_opts.limit)
      |> Ash.read!

    IO.inspect(posts)
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
    |> assign(:post_count, posts.count)
    |> stream(:posts, posts.results)

  end

  @impl true
  def handle_info({BlogDemoWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Ash.get!(BlogDemo.Blog.Post, id)
    Ash.destroy!(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end

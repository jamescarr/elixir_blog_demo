defmodule Mix.Tasks.CreatePosts do
  use Mix.Task

  @shortdoc "Creates a specified number of Post records."

  @moduledoc """
  This task will create a given number of Post records.

      mix create_posts 10
  """

  def run(args) do
    # This ensures that your app (and its Repo) are started,
    # so that your Ash actions can interact with the database.
    Mix.Task.run("app.start")

    # Parse the arguments to determine how many Posts to create.
    number_of_posts = parse_args(args)

    for i <- 1..number_of_posts do
      # Here we call the action we defined in the resource:
      #   define :create_post, action: :create
      # You can pass any other attributes as needed (e.g. content).
      params = %{
        title: "Post ##{i}",
        content: "Seeded Content for Post ##{i}",
      }

      MyAshPhoenixApp.Blog.create_post!(params)
      IO.puts("Created Post ##{i}")

    end
  end

  defp parse_args([count]) do
    case Integer.parse(count) do
      {parsed_count, ""} ->
        parsed_count

      _ ->
        raise ArgumentError,
              "Invalid argument '#{count}'. Please provide a single integer, e.g. `mix create_posts 10`"
    end
  end

  defp parse_args(_args) do
    raise ArgumentError,
          "Expected a single integer argument, e.g. `mix create_posts 10`."
  end
end

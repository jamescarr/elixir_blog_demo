# BlogDemo

A simple blog demo utilizing ash framework and the ash_json_api extension.

## Running It
Run `docker-compose up -d` to run the postgresql server if you aren't running
one already locally.

1. `mix ash.setup`
2. `mix ash.migrate`
3. `mix blog_demo.create_posts 1000`
4. Navigate to `http://localhost:4000/posts`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Development
There is a helper task to generate blog posts.

```
mix blog_demo.create_posts 1000
```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

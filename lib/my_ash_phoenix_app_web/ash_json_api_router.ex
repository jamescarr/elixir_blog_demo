defmodule MyAshPhoenixAppWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Module.concat(["MyAshPhoenixApp.Blog"])],
    open_api: "/open_api"
end

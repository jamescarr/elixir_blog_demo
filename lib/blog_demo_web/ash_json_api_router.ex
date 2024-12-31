defmodule BlogDemoWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Module.concat(["BlogDemo.Blog"])],
    open_api: "/open_api"
end

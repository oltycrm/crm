defmodule CrmWeb.Router do
  use CrmWeb, :router

  import CrmWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {CrmWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :admin_layout do
    plug(:put_root_layout, {CrmWeb.LayoutView, :admin})
  end

  pipeline :react_layout do
    plug(:put_root_layout, {CrmWeb.LayoutView, :react})
  end

  pipeline :marketing_layout do
    plug(:put_root_layout, {CrmWeb.LayoutView, :marketing})
  end

  pipeline :chat_layout do
    plug(:put_root_layout, {CrmWeb.LayoutView, :chat})
  end

  scope "/admin", CrmWeb do
    pipe_through([:browser, :admin_layout, :require_authenticated_user])

    # Users
    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings", UserSettingsController, :update)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)
    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :edit)
    post("/users/confirm/:token", UserConfirmationController, :update)

    # Clients
    live("/clients", ClientLive.Index, :index)
    live "/clients/modal/:size", ClientLive.Index, :modal
    live("/clients/new", ClientLive.Index, :new)
    live("/clients/:client_id/edit", ClientLive.Index, :edit)
    live("/clients/:client_id", ClientLive.Show, :show)
    live("/clients/:client_id/new_deal", ClientLive.Show, :new_deal)
    # post("/clients/:client_id/new_deal", ClientLive.Show, :new_deal)
    live("/clients/:client_id/show/edit", ClientLive.Show, :edit)

    live(
      "/clients/:client_id/sony_accounts/:sony_account_id/delete",
      ClientLive.Show,
      :delete_sony
    )

    # Sony Accounts
    live "/sony_accounts", SonyAccountLive.Index, :index
    live "/sony_accounts/new/", SonyAccountLive.Index, :new
    live "/sony_accounts/new/:client_id", SonyAccountLive.Index, :new
    live "/sony_accounts/:id/edit", SonyAccountLive.Index, :edit
    live "/sony_accounts/:id", SonyAccountLive.Show, :show
    live "/sony_accounts/:id/show/edit", SonyAccountLive.Show, :edit

    # Deals
    live "/deals", DealLive.Index, :index
    live "/deals/lead", DealLive.Index, :lead
    live "/deals/work", DealLive.Index, :work
    live "/deals/closed", DealLive.Index, :closed
    live "/deals/new", DealLive.Index, :new
    live "/deals/new/:client_id", DealLive.Index, :new
    live "/deals/:deal_id/edit", DealLive.Index, :edit
    # live "/deals/:deal_id/new_transaction", DealLive.Index, :new_transaction
    live "/deals/:id", DealLive.Show, :show
    # live "/deals/lead/:deal_id/edit", DealLive.Index, :edit
    live "/deals/:id/show/edit", DealLive.Show, :edit

    # Transactions
    live "/transaction", TransactionLive.Index, :index
    live "/transaction/new", TransactionLive.Index, :new
    # live "/transaction/new/:deal_id", TransactionLive.Index, :new
    live "/transaction/new/:deal_id/card/:card_id", TransactionLive.Index, :new
    live "/transaction/:id/edit", TransactionLive.Index, :edit
    live "/transaction/:id", TransactionLive.Show, :show
    live "/transaction/:id/show/edit", TransactionLive.Show, :edit

    # Tasks
    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit
    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/show/edit", TaskLive.Show, :edit

    # Cards
    get "/cards/dead", CardController, :dead
    resources "/cards", CardController

    # Products
    resources "/products", ProductController

    # Admin
    live("/", AdminLive, :index)
  end

  scope "/admin", CrmWeb do
    pipe_through [:browser, :chat_layout, :require_authenticated_user]

    # Tasks
    live "/chats", ChatLive.Index, :index
    live "/chats/new", ChatLive.Index, :new
    live "/chats/:id/edit", ChatLive.Index, :edit
    live "/chats/:id", ChatLive.Show, :show
    live "/chats/:id/show/edit", ChatLive.Show, :edit
  end

  ## Authentication routes
  scope "/", CrmWeb do
    pipe_through([:browser, :marketing_layout, :redirect_if_user_is_authenticated])

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  ## Some Stuff
  scope "/", CrmWeb do
    pipe_through([:browser, :marketing_layout, :redirect_if_user_is_authenticated])

    get("/", PageController, :index)

    get "/components", PageController, :components
    live "/components/live", PageLive, :index

    live "/live/modal/:size", PageLive, :modal
    live "/live/slide_over/:origin", PageLive, :slide_over
    live "/live/pagination/:page", PageLive, :pagination
  end

  scope "/react", CrmWeb do
    pipe_through [:browser, :react_layout]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrmWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through(:browser)

  #     live_dashboard("/dashboard", metrics: CrmWeb.Telemetry)
  #   end
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  # if Mix.env() == :dev do
  #   scope "/dev" do
  #     pipe_through(:browser)

  #     forward("/mailbox", Plug.Swoosh.MailboxPreview)
  #   end
  # end

  # pipeline :api do
  #   plug(:accepts, ["json"])
  # end
end

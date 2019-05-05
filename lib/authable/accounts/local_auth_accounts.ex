defmodule Authable.LocalAuthAccounts do
  @behaviour Authable.AuthAccounts

  alias Authable.AuthAccounts

  use Authable.RepoBase

  import Authable.Config, only: [scopes: 0, repo: 0]
  import Ecto.Query, only: [from: 2]


  @impl AuthAccounts
  def find_user(user_id) do
    repo().get_by(@resource_owner, id: user_id)
  end

  @impl AuthAccounts
  def find_user_by_email(email) do
    repo().get_by(@resource_owner, email: email)
  end

  @impl AuthAccounts
  def find_client(client_id) do
    repo().get_by(@client, id: client_id)
  end

  @impl AuthAccounts
  def find_client(client_id, redirect_uri) do
    repo().get_by(@client, id: client_id, redirect_uri: redirect_uri)
  end


  @impl AuthAccounts
  def find_token({token_name, token_value}) do
    repo().get_by(@token_store, value: token_value, name: token_name)
  end

  @impl AuthAccounts
  def token_expired?(token) do
    token.expires_at < :os.system_time(:seconds)
  end

  @impl AuthAccounts
  def revoke_app(app_id, user_id) do
    app = repo().get_by!(@app, id: app_id, user_id: user_id)
    repo().delete!(app)

    query =
      from(
        t in @token_store,
        where:
          t.user_id == ^app.user_id and
            fragment("?->>'client_id' = ?", t.details, ^app.client_id)
      )

    repo().delete_all(query)
  end

  def find_app_by_client(user_id, client_id) do
    repo().get_by(@app, user_id: user_id, client_id: client_id)
  end

  def create_app(user, client_id, scope) do
    changeset =
      @app.changeset(%@app{}, %{
        user_id: user.id,
        client_id: client_id,
        scope: scope
      })

    repo().insert!(changeset)
  end

  def update_app_scopes(app, scope) do
    if app.scope != scope do
      scope =
        scope
        |> Authable.Utils.String.comma_split()
        |> Enum.concat(Authable.Utils.String.comma_split(app.scope))
        |> Enum.uniq()

      scope = scopes() -- scopes() -- scope
      repo().update!(@app.changeset(app, %{scope: Enum.join(scope, ",")}))
    else
      app
    end
  end

end

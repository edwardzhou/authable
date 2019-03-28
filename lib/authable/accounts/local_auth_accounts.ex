defmodule Authable.LocalAuthAccounts do
  @behaviour Authable.AuthAccounts

  alias Authable.AuthAccounts

  use Authable.RepoBase

  import Authable.Config, only: [repo: 0]

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


end

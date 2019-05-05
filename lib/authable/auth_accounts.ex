defmodule Authable.AuthAccounts do

  @doc """

  """
  @callback find_user(user_id :: bitstring()) :: any() | nil

  @callback find_user_by_email(email :: bitstring()) :: any() | nil

  @callback find_app(app_id :: bitstring(), user_id :: bitstring()) :: any() | nil

  @callback find_client(client_id :: bitstring()) :: any() | nil

  @callback find_client(client_id :: bitstring(), redirect_uri :: bitstring()) :: any() | nil

  @callback find_token({token_name :: bitstring(), token_value :: bitstring()}) :: any() | nil

  @callback token_expired?(token :: any()) :: true | false

  @callback revoke_app(app_id :: bitstring(), user_id :: bitstring()) :: nil

  def find_user(auth_accounts_impl, user_id) do
    auth_accounts_impl.find_user(user_id)
  end

  def find_user_by_email(auth_accounts_impl, email) do
    auth_accounts_impl.find_user_by_email(email)
  end

  def find_client(auth_accounts_impl, client_id, redirect_uri) do
    auth_accounts_impl.find_client(client_id, redirect_uri)
  end
end

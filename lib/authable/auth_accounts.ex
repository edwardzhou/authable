defmodule Authable.AuthAccounts do

  @doc """

  """
  @callback find_user(user_id :: bitstring()) :: {:ok, any()} | {:error, term()}

  @callback find_user_by_email(email :: bitstring()) :: {:ok, any()} | {:error, term()}

  @callback find_app(app_id :: bitstring(), user_id :: bitstring()) :: {:ok, any()} | {:error, term()}

  @callback find_client(client_id :: bitstring()) :: {:ok, any()} | {:error, term()}

  @callback find_client(client_id :: bitstring(), redirect_uri :: bitstring()) :: {:ok, any()} | {:error, term()}

  @callback find_token(token_name :: bitstring(), token_value :: bitstring()) :: {:ok, any()} | {:error, term()}

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

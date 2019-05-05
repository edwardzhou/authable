defmodule Authable.Authentication.Token do
  @moduledoc """
  Base token authentication helper, implements Authable.Authentication
  behaviour. Differently from Bearer or Session, this module is a generic
  helper module. It enables to match with any token type from
  'token store(Authable.Token)'.
  """

  # use Authable.RepoBase
  import Authable.Config, only: [auth_accounts: 0]
  alias Authable.Authentication.Error, as: AuthenticationError

  @behaviour Authable.Authentication

  @doc """
  Authenticates resource-owner using given token name and value pairs.

  It matches resource owner with given token name and value.
  If any resource owner matched given credentials,
  it returns `Authable.Model.User` struct, otherwise
  `{:error, Map, :http_status_code}`.

  ## Examples

      # Suppose we store a confirmation_token at 'token store'
      # with token value "ct123456789"
      # If we pass the token value to the function,
      # it will return resource-owner.
      Authable.Authentication.Token.authenticate({"confirmation_token",
        "ct123456789"}, ["read", "write"])
  """
  def authenticate({token_name, token_value}, required_scopes) do
    {token_name, token_value}
    |> auth_accounts().find_token()
    |> token_check(required_scopes)
  end

  defp token_check(nil, _),
    do: AuthenticationError.invalid_token("Token not found.")

  defp token_check(token, required_scopes) do
    if auth_accounts().token_expired?(token) do
      AuthenticationError.invalid_token("Token expired.")
    else
      scopes = Authable.Utils.String.comma_split(token.details["scope"])

      if Authable.Utils.List.subset?(scopes, required_scopes) do
        token.user_id
        |> auth_accounts().find_user()
        |> resource_owner_check()
      else
        AuthenticationError.insufficient_scope(required_scopes)
      end
    end
  end

  defp resource_owner_check(nil),
    do: AuthenticationError.invalid_token("User not found.")

  defp resource_owner_check(resource_owner), do: {:ok, resource_owner}
end

defmodule Authable.LocalAuthAccountsTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoBase
  import Authable.Factory

  alias Authable.LocalAuthAccounts, as: Accounts

  @nonexist_user_id "00000000-1111-2222-3333-444444444444"
  @nonexist_client_id "00000000-1111-2222-3333-444444444441"
  @nonexist_email "nonexist@email.com"

  @redirect_uri "https://xyz.com/rd"
  # @email "username@abc.com"

  setup do
    user = insert(:user)
    client = insert(:client, user_id: user.id, redirect_uri: @redirect_uri)

    {:ok, [user: user, client: client]}
  end

  describe "#find_resource_owner" do
    test "return resource_owner with exists user_id", %{user: %{id: user_id}} do
      assert %{id: ^user_id} = Accounts.find_user(user_id)
    end

    test "return nil with nonexist user_id" do
      assert nil == Accounts.find_user(@nonexist_user_id)
    end
  end

  describe "#find_user_by_email" do
    test "return resource_owner with exists email", %{user: %{email: email}} do
      assert %{email: ^email} = Accounts.find_user_by_email(email)
    end

    test "return resource_owner with nonexists email" do
      assert nil == Accounts.find_user_by_email(@nonexist_email)
    end
  end

  describe "#find_client/1" do
    test "return client with exists client_id", %{client: %{id: client_id}} do
      assert %{id: ^client_id} = Accounts.find_client(client_id)
    end

    test "return nil with nonexist client_id" do
      assert nil == Accounts.find_client(@nonexist_user_id)
    end
  end

  describe "#find_client/2" do
    test "return client with exists client_id", %{client: %{id: client_id}} do
      assert %{id: ^client_id} = Accounts.find_client(client_id, @redirect_uri)
    end

    test "return nil with exists client_id and unmatched uri", %{client: %{id: client_id}} do
      assert nil == Accounts.find_client(client_id, @redirect_uri <> "__1")
    end

    test "return nil with nonexist client_id", %{client: %{id: _client_id}} do
      assert nil == Accounts.find_client(@nonexist_client_id, @redirect_uri)
    end
  end


end

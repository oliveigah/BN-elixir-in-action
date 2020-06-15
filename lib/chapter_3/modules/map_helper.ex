defmodule Chapter3.MapHelper do
  @moduledoc """
    This module explain how to use the `with` special form

    Book section: 3.3
  """
  defp extract_login(%{"login" => login}), do: {:ok, login}
  defp extract_login(_), do: {:error, "login missing"}

  defp extract_email(%{"email" => email}), do: {:ok, email}
  defp extract_email(_), do: {:error, "email missing"}

  defp extract_password(%{"password" => password}), do: {:ok, password}
  defp extract_password(_), do: {:error, "password missing"}

  @spec normalize_user!(map()) ::
          {:error, String.t()}
          | {:ok, %{email: String.t(), login: String.t(), password: String.t()}}

  @doc """
  Normalize a map to a map containing :login, :email and :password keys

  Book section: 3.3.3

  This exercises shows how to use `with` macro and pattern matching to achieve more elegant code.

  Without `with` a chain of `case` or `if` would be necessary.

  ## Examples
      iex> Chapter3.MapHelper.normalize_user!(%{"wrong" => "data"})
      {:error, "login missing"}

      iex> Chapter3.MapHelper.normalize_user!(%{"login" => "example"})
      {:error, "email missing"}

      iex> Chapter3.MapHelper.normalize_user!(%{"login" => "example", "email" => "example@email.com"})
      {:error, "password missing"}

      iex> Chapter3.MapHelper.normalize_user!(%{"login" => "example", "email" => "example@email.com", "password" => "secret", "other" => "data"})
      {:ok, %{login: "example", email: "example@email.com", password: "secret"}}

  """
  def normalize_user!(user) do
    with {:ok, login} <- extract_login(user),
         {:ok, email} <- extract_email(user),
         {:ok, password} <- extract_password(user) do
      {:ok, %{login: login, email: email, password: password}}
    end
  end
end

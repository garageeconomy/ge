defmodule GE.Auth do

  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false

  alias Comeonin.Bcrypt
  alias Ecto.Multi



  def list_users do
    list_users(100, 0)
  end

  def list_users(limit, offset) do

    query =
      from u in m_user(), limit: ^limit, offset: ^offset

    repo().all query

  end


  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: repo().get!(m_user(), id)

  def get_user_by_ident_hash(ident_hash) do

    m_user = m_user()
    m_user_ident = m_user_ident()

    query =
      from ui in m_user_ident(),
           join: u in ^m_user, on: u.id == ui.user_id,
           where: ui.hash == ^ident_hash,
           select: %m_user{
             id: u.id,
             name: u.name,
             email: u.email,
             phone_number: u.phone_number,
             users_idents: [%m_user_ident{
               id: ui.id,
               type: ui.type,
               key: ui.key,
               user_id: ui.user_id,
               hash: ui.hash,
               auth_data: ui.auth_data
             }]
           }
    repo().one query
  end

  def get_ident_by_key(key) do
    m_user_ident() |> repo().get_by(key: key)
  end

  def get_ident_by_hash(ident_hash) do
    m_user_ident() |> repo().get_by(hash: ident_hash)
  end



  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(user_attrs \\ %{}, user_ident_attrs \\ %{}) do

    Multi.new
    |> Multi.insert(:user, m_user().changeset(m_user().__struct__(%{}), user_attrs))

    |> Multi.run(:user_ident, fn %{user: user} ->
      repo().insert(m_user_ident().changeset(m_user_ident().__struct__(%{}), %{user_ident_attrs|user_id: user.id}))
    end)

  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(user, attrs) do
    user
    |> m_user().changeset(attrs)
    |> repo().update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(user) do
    repo().delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(user) do
    m_user().changeset(user, %{})
  end

  def authenticate_user_by_email_and_password(email, plain_text_password) do

    m_user = m_user()

    query =
      from ui in m_user_ident(),
           join: u in ^m_user, on: u.id == ui.user_id,
           where: ui.type == "email_pw" and ui.key == ^email,
           select: %m_user{
             id: u.id,
             name: u.name,
             users_idents: [%m_user_ident(){
               auth_data: ui.auth_data
             }]
           }

    case repo().one(query) do
      nil -> {:error, "User not found"}
      user ->
        check_password(user, plain_text_password)
    end
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}

  defp check_password(%{users_idents: [%{auth_data: nil}]}, _), do: {:error, "Incorrect username or password"}

  defp check_password(%{users_idents: [%{auth_data: password_encoded}]} = user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, password_encoded) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end



  defp repo(), do: cv(:repo)

  defp m_user(), do: cv(:m_user)

  defp m_user_ident(), do: cv(:m_user_ident)

  defp cv(param), do: Application.get_env(:ge, __MODULE__)[param]

end

defmodule GE.Auth.Guardian do

  use Guardian, otp_app: :ge
  alias GE.Auth

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do

    case Auth.get_user(claims["sub"]) do
      nil -> {:error, :no_user}
      user -> {:ok, user}
    end

  end

end
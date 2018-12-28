defmodule GE.Auth.Pipeline do

  @error_handler Application.get_env(:ge, __MODULE__)[:error_handler] ||
                 GE.Auth.ErrorHandler

  use Guardian.Plug.Pipeline,
      otp_app: :ge,
      error_handler: @error_handler,
      module: GE.Auth.Guardian

  # If there is a session token, validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug :maybe_user

  defp maybe_user(%{assigns: assigns} = conn, _params) do

    maybe_user = Guardian.Plug.current_resource(conn)
    
    conn = %{conn | assigns: Map.put_new(assigns, :maybe_user, maybe_user)}

    conn

  end

end
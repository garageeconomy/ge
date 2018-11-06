defmodule GE.Model do

  import Ecto.Changeset

  def put_hash(%{data: %{hash: nil}} = changeset) do
    change(changeset, hash: EntropyString.random)
  end
  def put_hash(changeset), do: changeset

end
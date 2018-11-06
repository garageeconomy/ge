defmodule GETest do
  use ExUnit.Case
  doctest GE

  test "greets the world" do
    assert GE.hello() == :world
  end
end

defmodule ElixirAnnouncerTest do
  use ExUnit.Case
  doctest ElixirAnnouncer

  test "greets the world" do
    assert ElixirAnnouncer.hello() == :world
  end
end

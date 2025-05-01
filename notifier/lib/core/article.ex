defmodule Core.Article do
  @enforce_keys [:title, :url, :source]
  defstruct [
    title: "",
    url: "",
    description: "",
    id: nil,
    source: nil
  ]

  @type source_type :: :hackernews | :unknown

  @type t :: %__MODULE__{
    title: String.t(),
    url: String.t(),
    description: String.t() | nil,
    id: integer(),
    source: source_type()
  }
end

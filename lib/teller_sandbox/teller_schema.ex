defmodule Teller.TellerSchema do
  @moduledoc """
  The "top level" schema
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @type t :: %__MODULE__{}
      @primary_key false

      # We are not simply using @derive Jason.Encoder because that will cause
      # also the __meta__ field to be encoded, which is not something Ecto is
      # happy about (it's in internal Ecto field and should not be exposed)
      defimpl Jason.Encoder do
        def encode(struct, opts) do
          # This wont include virtual fields do be aware...
          Map.take(struct, struct.__struct__.__schema__(:fields))
          |> Jason.Encode.map(opts)
        end
      end
    end
  end
end

defmodule CoopGame.Model.Storage do
  alias :mnesia, as: Mnesia

  @player_table Player
  @player_fields [
    :id,
    :name,
    :token
  ]

  def init do
    Mnesia.create_schema([node()])
    Mnesia.start()

    create_table(@player_table, @player_fields)
  end




## PRIVATE ##


  defp create_table(table_name, attributes) do
    response =
      Mnesia.create_table(
        table_name,
        [attribute: attributes
        ]
      )
  end
end

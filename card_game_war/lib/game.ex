defmodule CardGameWar.Game do

  defmodule Card do
    defstruct [:rank, :suit]
  end
  # feel free to use these cards or use your own data structure"
  def suits, do: [:spade, :club, :diamond, :heart]
  def ranks, do: [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  def cards do
    for suit <- suits(),
        rank <- ranks() do
      %Card{suit: suit, rank: rank}
    end
  end
  def get_higher(card_1, card_2) do
    index_1 = Enum.find_index(ranks(), &(&1 == card_1.rank))
    index_2 = Enum.find_index(ranks(), &(&1 == card_2.rank))
    cond do
      index_1 > index_2 ->
        card_1
      index_1 < index_2 ->
        card_2
      true -> 
         cond do
           Enum.find_index(suits(), &(&1 == card_1.suit)) > Enum.find_index(suits(), &(&1 == card_2.suit)) ->
             card_1
           true -> 
             card_2
         end
    end
  end

  def play() do
    {deck_player_1, deck_player_2} = Enum.shuffle(CardGameWar.Game.cards) |> Enum.split(26)
    play(26, 26, deck_player_1, deck_player_2) 
  end

  def play(0, _, _, _) do
    "Player 2 wins"
  end
  def play(_, 0, _, _) do
    "Player 1 wins"
  end
  def play(_, _, deck_player_1, deck_player_2) do
    [card_player_1 | deck_player_1] = deck_player_1
    [card_player_2 | deck_player_2] = deck_player_2
    IO.inspect("Player 1 plays: " <> inspect(card_player_1.rank) <> " " <> inspect(card_player_1.suit))
    IO.inspect("Player 2 plays: " <> inspect(card_player_2.rank) <> " " <> inspect(card_player_2.suit))
    #IO.inspect(length(deck_player_1))
    #IO.inspect(length(deck_player_2))
    cond do
      get_higher(card_player_1, card_player_2) == card_player_1 ->
        IO.inspect("Player 1 won round")
        deck_player_1 = [card_player_1 | Enum.reverse deck_player_1]
        deck_player_1 = [card_player_2 | deck_player_1]
        play(length(deck_player_1), length(deck_player_2), Enum.reverse(deck_player_1), deck_player_2)
      true ->
        IO.inspect("Player 2 won round")
        deck_player_2 = [card_player_2 | Enum.reverse deck_player_2]
        deck_player_2 = [card_player_1 | deck_player_2]
        play(length(deck_player_1), length(deck_player_2), deck_player_1, Enum.reverse(deck_player_2))
    end
  end
end

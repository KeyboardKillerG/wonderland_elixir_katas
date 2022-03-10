defmodule AlphabetCipher.Coder do
  def abc(), do: 'abcdefghijklmnopqrstuvwxyz' |> Enum.with_index

  def encode(keyword, message) do
    keyword = String.duplicate(keyword, ceil(String.length(message) / String.length(keyword)))
              |>String.downcase
              |> String.to_charlist
    message = message
              |> String.downcase 
              |> String.to_charlist
    Enum.zip_with(keyword, message, fn k, m -> 
      {^k, k_index} = List.keyfind(abc(), k, 0)
      {^m, m_index} = List.keyfind(abc(), m, 0)
      cond do
        m_index + k_index >= length(abc()) ->
          {e, _}= List.keyfind(abc(), m_index + k_index - length(abc()), 1)
          e
        true ->
          {e, _} = List.keyfind(abc(), m_index + k_index, 1)
          e
      end
    end) |> List.to_string
  end

  def decode(keyword, message) do
    keyword = String.duplicate(keyword, ceil(String.length(message) / String.length(keyword)))
              |> String.to_charlist
    message = message |> String.to_charlist
    Enum.zip_with(keyword, message, fn k, m -> 
      {^k, k_index} = List.keyfind(abc(), k, 0)
      {^m, m_index} = List.keyfind(abc(), m, 0)
      cond do
        m_index - k_index >= 0 ->
          {d, _}= List.keyfind(abc(), m_index - k_index , 1)
          d 
        true ->
          {d, _} = List.keyfind(abc(), m_index + length(abc()) - k_index, 1, {35,0})
          d
          #35
      end
    end) |> List.to_string
  end

  def decipher(cipher, message) do
    cipher = cipher |> String.to_charlist
    message = message |> String.to_charlist
    c = Enum.zip_with(cipher, message, fn e, m -> 
      {^e, e_index} = List.keyfind(abc(), e, 0)
      {^m, m_index} = List.keyfind(abc(), m, 0)
      cond do
        e_index - m_index < 0 ->
          {d, _}= List.keyfind(abc(), e_index - m_index + length(abc()) , 1, {33,0})
          d 
        true ->
          {d, _} = List.keyfind(abc(), e_index - m_index, 1, {35,0})
          d
          #35
      end
    end)
    [key_length | _] = Enum.filter(1..length(c), fn x ->
      {candidate, _} = Enum.split(c, x) 
      candidate = candidate |> List.to_string
      candidate_t = candidate |> String.duplicate(ceil(length(message)/String.length(candidate)))
      String.contains?(candidate_t, List.to_string(c))
    end)
    {keyword, _ } = Enum.split(c, key_length) 
    keyword |> List.to_string
  end
end

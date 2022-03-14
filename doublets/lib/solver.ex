defmodule Doublets.Solver do
  import String
  defp words do
    "./resources/words.txt"
      |> File.stream!
      |> Enum.to_list
  end
  
  def doublets(word1, word2) do
    cond do
      String.length(word1) == String.length(word2) -> 
        l = [word1 | doublets(word1, word2, words())]
        cond do
          Enum.member?(l, "No answer") ->
            []
          true -> l
        end
      true -> []
    end
  end

  defp doublets(word1, word2, dic) when word1 != word2 do
    w_l = Enum.map(dic, &trim(&1)) 
          |> Enum.filter(fn w -> String.length(word1) == String.length(w) end)
          |> List.delete(word1)
          #|> List.delete(word2)
    w = hd Enum.sort_by(w_l, &{Simetric.Levenshtein.compare(&1, word1), Simetric.Levenshtein.compare(&1, word2)}, :asc) |> IO.inspect()
    char_difference =  Enum.zip_reduce(String.to_charlist(word1), String.to_charlist(w), 0, fn x, y, acc ->
      cond do
      x != y -> acc + 1
      true -> acc
      end
    end)
    IO.inspect(word1)
    IO.inspect(w)
    IO.inspect(char_difference)
    cond do
      char_difference == 1 -> [w | doublets(w, word2, w_l)]
      true -> ["No answer"] 
    end
  end
  defp doublets(word1, word2, _) when word1 == word2 do 
     []
  end

end

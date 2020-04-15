defmodule Debt.Updater do
    @sticker_set_name "usadebt_by_usa_debt_bot"
    @output_path "./resources/images/result.png"
    @application :debt
    @emojis "💵"

    def update_sticker() do

        # get new debt value
        new_debt = get_debt_value()

        # check if it changed (save it in local file or persistance_term I guess)

        case :persistent_term.get(:debt, nil) do
            ^new_debt -> :ok;
            _ ->
                # get current sticker file id
                {:ok, %{stickers: stickers}} = Nadia.get_sticker_set(@sticker_set_name) # TODO: handle error
                old_id = get_first_sticker_file_id(stickers)
                # draw new sticker
                :ok = Debt.Draw.draw_debt(new_debt, @output_path) # TODO: handle error
                # add new sticker
                :ok = Nadia.add_sticker_to_set(user_id(), @sticker_set_name, @output_path, @emojis) # TODO: handle error
                # remove old sticker by it's id
                :ok = case old_id do
                    nil -> :ok;
                    _ -> Nadia.delete_sticker_from_set(old_id)
                end
                :ok
        end
    end

    defp get_first_sticker_file_id([]), do: nil
    defp get_first_sticker_file_id([%{file_id: file_id } | _]), do: file_id

    defp get_debt_value() do
        %{
            status_code: 200,
            body: body
        } = HTTPoison.get! "https://www.treasurydirect.gov/NP_WS/debt/current/", [], params: %{format: "json"}
        %{totalDebt: debt} = Jason.decode!(body, keys: :atoms)
        debt
        |> round
        |> Integer.to_charlist
        |> Enum.reverse
        |> Enum.chunk_every(3)
        |> Enum.reverse
        |> Enum.map(&Enum.reverse/1)
        |> Enum.join(",")
    
    end

defp user_id(), do: Application.get_env(@application, :user_id)

end

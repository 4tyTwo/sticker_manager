defmodule Debt.Updater do
    @sticker_set_name "usadebt_by_usa_debt_bot"
    @output_path "./resources/images/result.png"
    @application :debt
    @emojis "💵"
    @treasury_url "https://www.treasurydirect.gov/NP_WS/debt/current/"

    @type sticker :: Nadia.Model.Sticker.t()

    @spec update_sticker() :: :ok | {:error, term()}
    def update_sticker() do
        try do
            new_debt = get_debt_value()
            maybe_update_sticker new_debt
        catch
            error ->
                _ = Nadia.send_message(user_id(), "Failed to update sticker, error: #{inspect(error)}")
                error
        end
    end

    @spec get_debt_value() :: String.t()
    defp get_debt_value() do
        %{
            status_code: 200,
            body: body
        } = Debt.Utils.handle_result(HTTPoison.get! @treasury_url, [], params: %{format: "json"})
        {:ok, %{totalDebt: debt}} = Debt.Utils.handle_result(Jason.decode(body, keys: :atoms))
        format_debt debt
    end

    @spec format_debt(integer()) :: String.t()
    defp format_debt(debt) do
        debt
        |> round
        |> Integer.to_charlist
        |> Enum.reverse
        |> Enum.chunk_every(3)
        |> Enum.reverse
        |> Enum.map(&Enum.reverse/1)
        |> Enum.join(",")
    end

    @spec maybe_update_sticker(String.t()) :: :ok
    defp maybe_update_sticker(debt) do
        result = case :persistent_term.get(:debt, nil) do
            ^debt ->
                :not_updated # value is the same, no need to update
            _ ->
                do_update_sticker debt
                :persistent_term.put(:debt, debt)
                :updated
        end
        inform_me result, debt
        :ok
    end

    @spec do_update_sticker(String.t()) :: :ok
    defp do_update_sticker(debt) do
        old_id = get_sticker_to_remove_file_id()
        Debt.Utils.handle_result(Debt.Draw.draw_debt(debt, @output_path))
        Debt.Utils.handle_result(Nadia.add_sticker_to_set(user_id(), @sticker_set_name, @output_path, @emojis))
        case old_id do
            nil -> :ok;
            _ -> Debt.Utils.handle_result(Nadia.delete_sticker_from_set(old_id))
        end
    end

    @spec get_sticker_to_remove_file_id() :: String.t() | nil
    defp get_sticker_to_remove_file_id() do
        {:ok, %{stickers: stickers}} = Debt.Utils.handle_result(Nadia.get_sticker_set(@sticker_set_name))
        get_first_sticker_file_id(stickers)
    end

    @spec user_id() :: integer()
    defp user_id(), do: Application.get_env(@application, :user_id)

     @spec get_first_sticker_file_id([sticker()]) :: String.t() | nil
    defp get_first_sticker_file_id([]), do: nil
    defp get_first_sticker_file_id([%{file_id: file_id } | _]), do: file_id

    defp inform_me(:updated, debt), do: do_inform_me("Updated debt value, new debt is #{debt}")
    defp inform_me(:not_updated, _), do: do_inform_me("Debt value has not changed")

    defp do_inform_me(message) do
        Nadia.send_message(user_id(), message)
    end
end

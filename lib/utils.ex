defmodule Debt.Utils do
    @spec handle_result(result) :: no_return | result when result: term()
    def handle_result({:error, _} = error), do: throw error
    def handle_result(result), do: result
end

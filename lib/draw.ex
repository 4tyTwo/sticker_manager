
defmodule Draw do

    @application :debt

    @mogrify_params %{
        font: "ArialBI",
        font_size: "36",
        x_cord: 40,
        y_cord: 180,
        color: "rgb(255,0,0)"
    }

    def draw_debt(debt) do
        get_template_path()
        |> Mogrify.open()
        |> Mogrify.custom("font", @mogrify_params.font)
        |> Mogrify.custom("pointsize", @mogrify_params.font_size)
        |> Mogrify.custom("annotate", "+#{@mogrify_params.x_cord}+#{@mogrify_params.y_cord} $ #{debt}")
        |> Mogrify.custom("fill", @mogrify_params.color)
        |> Mogrify.save(path: "./resources/images/result.png")
    end

    defp get_template_path() do
        case Application.get_env(@application, :template_image_path) do
                nil -> raise "No template_image_path set"
                path -> path
        end
    end
end

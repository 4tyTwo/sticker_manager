use Mix.Config

# def host(), do: to_charlist System.get_env("PROXY_HOST")

# def port(), do: String.to_integer System.get_env("PROXY_PORT")

config :nadia,
    token: {:system, "BOT_TOKEN"},
    proxy: {
        :socks5,
        to_charlist(System.get_env("PROXY_HOST")),
        String.to_integer(System.get_env("PROXY_PORT"))
    },
    socks5_user: System.get_env("PROXY_USER"),
    socks5_pass: System.get_env("PROXY_PASS")



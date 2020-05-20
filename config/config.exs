use Mix.Config

# disable ELixir's logger cause it is awful
config :logger, backends: []

config :nadia,
  token: {:system, "BOT_TOKEN"},
  proxy: {
    :socks5,
    to_charlist(System.get_env("PROXY_HOST")),
    String.to_integer(System.get_env("PROXY_PORT"))
  },
  socks5_user: System.get_env("PROXY_USER"),
  socks5_pass: System.get_env("PROXY_PASS")

config :debt, Debt.Scheduler,
  jobs: [
    # Every 4 hours
    {"0 */4 * * *", {Debt.Updater, :update_sticker, []}},
  ]

config :debt, :logger, [
  {:handler, :default, :logger_std_h,
   %{
     :config => %{
       :type => {:file, 'console.json'}
     },
     :formatter =>
       {:logger_logstash_formatter,
        %{
          :exclude_meta_fields => [
            :ansi_color,
            :application,
            :file,
            :line,
            :mfa,
            :pid,
            :gl,
            :domain
          ]
        }}
   }},
  {:handler, Logger, :logger_std_h,
   %{
     :config => %{
       :type => {:file, 'console.json'}
     },
     :formatter =>
       {:logger_logstash_formatter,
        %{
          :exclude_meta_fields => [
            :ansi_color,
            :application,
            :file,
            :line,
            :mfa,
            :pid,
            :gl,
            :domain
          ]
        }}
   }}
]

config :debt,
  # strictly 512x512 pixels!
  template_image_path: "./resources/images/sticker_template.png",
  bot_token_path: "./resources/bot.token",
  user_id: String.to_integer(System.get_env("USER_ID")),
  secret: System.get_env("SECRET")

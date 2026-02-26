defmodule BuscaEstagio.Scraper do
  use Ash.Domain,
    otp_app: :busca_estagio

  resources do
    resource BuscaEstagio.Scraper.USP
  end
end

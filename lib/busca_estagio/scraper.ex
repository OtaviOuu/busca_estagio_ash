defmodule BuscaEstagio.Scraper do
  use Ash.Domain,
    otp_app: :busca_estagio

  resources do
    resource BuscaEstagio.Scraper.USP do
      define :scrape_usp_internships, action: :scrape_usp_eesc_internships
    end
  end
end

defmodule BuscaEstagio.Scraper do
  use Ash.Domain,
    otp_app: :busca_estagio

  resources do
    resource BuscaEstagio.Scraper.USP do
      define :scrape_usp_internships, action: :scrape
    end

    resource BuscaEstagio.Scraper.UFMG do
      define :scrape_ufmg_icex_internships, action: :scrape
    end
  end
end

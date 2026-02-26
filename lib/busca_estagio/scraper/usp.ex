defmodule BuscaEstagio.Scraper.USP do
  use Ash.Resource,
    otp_app: :busca_estagio,
    domain: BuscaEstagio.Scraper

  actions do
    action :scrape_usp_eesc_internships do
      run BuscaEstagio.Scraper.Actions.ScrapeUspEescInternships
    end
  end
end

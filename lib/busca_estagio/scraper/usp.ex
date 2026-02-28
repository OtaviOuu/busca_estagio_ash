defmodule BuscaEstagio.Scraper.USP do
  use Ash.Resource,
    otp_app: :busca_estagio,
    domain: BuscaEstagio.Scraper

  actions do
    action :scrape_eesc, {:array, :struct} do
      run BuscaEstagio.Scraper.Actions.ScrapeUspEescInternships
    end

    action :scrape_fearp, {:array, :struct} do
      run BuscaEstagio.Scraper.Actions.ScrapeUspFearpInternships
    end
  end
end

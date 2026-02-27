defmodule BuscaEstagio.Scraper.UFMG do
  use Ash.Resource,
    otp_app: :busca_estagio,
    domain: BuscaEstagio.Scraper

  actions do
    action :scrape, {:array, :struct} do
      run BuscaEstagio.Scraper.Actions.ScrapeUfmgIcexInternships
    end
  end
end

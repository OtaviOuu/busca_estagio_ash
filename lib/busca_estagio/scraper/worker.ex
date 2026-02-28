defmodule BuscaEstagio.Scraper.Worker do
  use Oban.Worker, queue: :default, max_attempts: 10

  def perform(_job) do
    with {:ok, ufmg_icex_attrs} <- BuscaEstagio.Scraper.scrape_ufmg_icex_internships(),
         {:ok, usp_icmc_attrs} <- BuscaEstagio.Scraper.scrape_usp_internships() do
      all_attrs = usp_icmc_attrs ++ ufmg_icex_attrs
      a = Ash.bulk_create(Enum.take(all_attrs, 4), BuscaEstagio.Internships.Internship, :create)
      IO.inspect(a)
      :ok
    end
  end
end

defmodule BuscaEstagio.Scraper.Worker do
  use Oban.Worker, queue: :default, max_attempts: 10

  require Logger

  def perform(_job) do
    Logger.info("Starting internship scraping...")

    with {:ok, ufmg_icex_attrs} <- BuscaEstagio.Scraper.scrape_ufmg_icex_internships(),
         {:ok, usp_eesc_attrs} <- BuscaEstagio.Scraper.scrape_usp_eesc_internships() do
      all_attrs =
        (usp_eesc_attrs ++ ufmg_icex_attrs) |> Enum.uniq_by(& &1.url)

      Ash.bulk_create(all_attrs, BuscaEstagio.Internships.Internship, :create,
        upsert?: true,
        upsert_identity: :unique_url,
        upsert_fields: [:title, :description, :source]
      )

      :ok
    end
  end
end

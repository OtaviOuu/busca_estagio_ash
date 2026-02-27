defmodule BuscaEstagio.Scraper.Worker do
  use Oban.Worker, queue: :default, max_attempts: 10

  def perform(_job) do
    case BuscaEstagio.Scraper.scrape_ufmg_icex_internships() do
      {:ok, internship_attrs} ->
        IO.inspect(internship_attrs)

        Ash.bulk_create(
          Enum.take(internship_attrs, 4),
          BuscaEstagio.Internships.Internship,
          :create
        )

        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end
end

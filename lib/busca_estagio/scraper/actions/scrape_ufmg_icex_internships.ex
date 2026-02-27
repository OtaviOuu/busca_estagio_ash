defmodule BuscaEstagio.Scraper.Actions.ScrapeUfmgIcexInternships do
  use Ash.Resource.Actions.Implementation
  require Logger
  @base_url "https://www.icex.ufmg.br/icex_novo"
  @source :ufmg_icex
  def run(_input, _opts, _context) do
    Logger.info("Starting to scrape internships from #{@source}...")

    with {:ok, urls} <- get_internships_urls() do
      urls
      |> Enum.map(&extract_internship_attrs_from_url/1)
      |> then(&{:ok, &1})
    end
  end

  defp get_internships_urls() do
    with {:ok, html_tree} <- get_html_tree(@base_url <> "/oportunidades") do
      html_tree
      |> Floki.find(".entry-content.clear .eael-timeline-post a")
      |> Floki.attribute("href")
      |> then(&{:ok, &1})
    end
  end

  defp extract_internship_attrs_from_url(url) do
    with {:ok, html_tree} <- get_html_tree(url) do
      html_tree = Floki.find(html_tree, "#main")

      title =
        html_tree
        |> Floki.find("h1.entry-title")
        |> Floki.text()
        |> String.trim()

      description =
        html_tree
        |> Floki.find("div.entry-content.clear")
        |> Floki.raw_html()

      %{title: title, description_html: description, source: @source}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_html_tree(url) do
    with {:ok, response} <- Req.get(url),
         {:ok, html_tree} <- Floki.parse_document(response.body) do
      {:ok, html_tree}
    end
  end
end

defmodule BuscaEstagio.Scraper.Actions.ScrapeUspEescInternships do
  use Ash.Resource.Actions.Implementation
  require Logger
  @base_url "https://eesc.usp.br/estagios"

  def run(_input, _opts, _context) do
    Logger.info("Starting to scrape internships from USP EESC...")

    with {:ok, urls} <- get_internships_urls() do
      urls
      |> Enum.map(&extract_internship_attrs_from_url/1)
      |> then(&{:ok, &1})
    end
  end

  defp get_internships_urls() do
    with {:ok, html_tree} <- get_html_tree(@base_url <> "/posts.php") do
      html_tree
      |> Floki.find("#v-pills-tabContent h5 a")
      |> Floki.attribute("href")
      |> Enum.map(&build_internship_full_url/1)
      |> then(&{:ok, &1})
    end
  end

  defp extract_internship_attrs_from_url(url) do
    with {:ok, html_tree} <- get_html_tree(url) do
      html_tree = Floki.find(html_tree, "#v-pills-tabContent")

      title =
        html_tree
        |> Floki.find("h5.title-not")
        |> Floki.text()
        |> String.trim()

      description =
        html_tree
        |> Floki.find("div.mt-4")
        |> Floki.raw_html()

      source = :usp_eesc
      %{title: title, description_html: description, source: source, url: url}
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

  defp build_internship_full_url(href) do
    @base_url <> "/" <> href
  end
end

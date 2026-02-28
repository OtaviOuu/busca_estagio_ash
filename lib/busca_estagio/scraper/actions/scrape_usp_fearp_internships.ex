defmodule BuscaEstagio.Scraper.Actions.ScrapeUspFearpInternships do
  use Ash.Resource.Actions.Implementation
  require Logger

  @base_url "https://www.fearp.usp.br"

  def run(_input, _opts, _context) do
    Logger.info("Starting to scrape internships from USP FEARP...")

    with {:ok, urls} <- get_internships_urls() do
      urls
      |> Task.async_stream(
        &extract_internship_attrs_from_url/1,
        max_concurrency: 20,
        timeout: 30_000,
        ordered: false
      )
      |> Enum.reduce([], fn
        {:ok, result}, acc ->
          [result | acc]

        {:error, reason}, acc ->
          Logger.error("Task failed: #{inspect(reason)}")
          acc
      end)
      |> then(&{:ok, &1})
    end
  end

  defp get_internships_urls() do
    with {:ok, html_tree} <- get_html_tree(@base_url <> "/estagio/item/1116-vagas-online.html") do
      html_tree
      |> Floki.find("#k2Container .itemBody a")
      |> Floki.attribute("href")
      |> Enum.reduce([], fn href, acc ->
        if String.contains?(href, ".pdf") do
          [href | acc]
        else
          acc
        end
      end)
      |> Enum.map(&build_internship_full_url/1)
      |> then(&{:ok, &1})
    end
  end

  # Recruta_Agora_agente_integrador_-_Estágio_Comercial.pdf
  defp extract_internship_attrs_from_url(url) do
    title =
      url
      |> String.split("/")
      |> List.last()
      |> String.replace("-", " ")
      |> String.replace("_", " ")
      |> String.replace("   ", " ")
      |> String.replace("  ", " ")
      |> String.replace(".pdf", "")
      |> String.trim()

    source = :usp_fearp
    pdf_iframe_html = "<iframe src='#{url}' width='100%' height='600px'></iframe>"
    %{title: title, description_html: pdf_iframe_html, source: source, url: url}
  end

  defp get_html_tree(url) do
    with {:ok, response} <- Req.get(url),
         {:ok, html_tree} <- Floki.parse_document(response.body) do
      {:ok, html_tree}
    end
  end

  defp build_internship_full_url(href) do
    @base_url <> href
  end
end

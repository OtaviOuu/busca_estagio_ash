defmodule BuscaEstagioWeb.InternshipsLive.Show do
  use BuscaEstagioWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      BuscaEstagio.Internships.view_internship(id)
    end

    socket
    |> assign(:internship, BuscaEstagio.Internships.get_internship!(id))
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        {@internship.title}

        <:subtitle>
          <.url_barge url={@internship.url} />
        </:subtitle>
      </.header>
      <div>{raw(@internship.description)}</div>
    </Layouts.app>
    """
  end

  defp url_barge(assigns) do
    ~H"""
    <a href={@url} class="text-blue-500 hover:underline" target="_blank" rel="noopener noreferrer">
      Ver no site de origem
    </a>
    """
  end
end

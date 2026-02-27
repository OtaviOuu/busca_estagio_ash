defmodule BuscaEstagioWeb.InternshipsLive.Show do
  use BuscaEstagioWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    socket
    |> assign(:internship, BuscaEstagio.Internships.get_internship!(id))
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>{@internship.title}</.header>
      <div>{raw(@internship.description)}</div>
    </Layouts.app>
    """
  end
end

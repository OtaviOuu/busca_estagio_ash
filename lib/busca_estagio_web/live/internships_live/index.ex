defmodule BuscaEstagioWeb.InternshipsLive.Index do
  use BuscaEstagioWeb, :live_view

  def mount(params, session, socket) do
    socket
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <Cinder.collection
        resource={BuscaEstagio.Internships.Internship}
        click={fn internship -> JS.navigate(~p"/internships/#{internship.id}") end}
      >
        <:col :let={internship} field="title" filter sort>{internship.title}</:col>
        <:col :let={internship} field="source" filter sort>{internship.source}</:col>
        <:col :let={internship} field="inserted_at" filter sort>{internship.inserted_at}</:col>
      </Cinder.collection>
    </Layouts.app>
    """
  end
end

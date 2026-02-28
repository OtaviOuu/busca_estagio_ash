defmodule BuscaEstagioWeb.InternshipsLive.Index do
  use BuscaEstagioWeb, :live_view

  def mount(params, _session, socket) do
    socket
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <Cinder.collection
        page_size={[default: 10, options: [10, 25, 50, 100]]}
        resource={BuscaEstagio.Internships.Internship}
        click={fn internship -> JS.navigate(~p"/internships/#{internship.id}") end}
      >
        <:col :let={internship} field="title" filter sort>
          {internship.title} <.is_new_badge :if={internship.is_new?} />
        </:col>
        <:col
          :let={internship}
          field="source"
          filter={[
            type: :select,
            options: [
              {"USP-EESC", "usp_eesc"},
              {"USP-ICMC", "usp_icmc"},
              {"UFMG-ICEX", "ufmg_icex"}
            ]
          ]}
          sort
        >
          <.uni_badge source={internship.source} />
        </:col>
        <:col :let={internship} field="inserted_at" sort>
          {internship.inserted_at |> DateTime.to_date() |> Date.to_string()}
        </:col>
      </Cinder.collection>
    </Layouts.app>
    """
  end

  defp uni_badge(%{source: :usp_eesc} = assigns) do
    ~H"""
    <div class="badge badge-secundary">USP-EESC</div>
    """
  end

  defp uni_badge(%{source: :usp_icmc} = assigns) do
    ~H"""
    <div class="badge badge-secundary">USP-ICMC</div>
    """
  end

  defp uni_badge(%{source: :ufmg_icex} = assigns) do
    ~H"""
    <div class="badge badge-secundary">UFMG-ICEX</div>
    """
  end

  defp is_new_badge(assigns) do
    ~H"""
    <div class="badge badge-success">Nova</div>
    """
  end
end

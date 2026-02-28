defmodule BuscaEstagioWeb.InternshipsLive.Index do
  use BuscaEstagioWeb, :live_view
  import Cinder

  def mount(params, _session, socket) do
    if connected?(socket) do
      BuscaEstagioWeb.Endpoint.subscribe("internship:viewed")
    end

    socket
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <Cinder.collection
        id="internships-collection"
        page_size={[default: 10, options: [10, 25, 50, 100]]}
        resource={BuscaEstagio.Internships.Internship}
        click={fn internship -> JS.navigate(~p"/internships/#{internship.id}") end}
      >
        <:col :let={internship} field="title" filter sort>
          {format_title(internship.title)}
        </:col>
        <:col :let={internship} field="views" sort>
          <.views_badge views={internship.views} />
        </:col>
        <:col
          :let={internship}
          field="source"
          filter={[
            type: :select,
            options: [
              {"USP-EESC", "usp_eesc"},
              {"USP-ICMC", "usp_icmc"},
              {"UFMG-ICEX", "ufmg_icex"},
              {"USP-FEARP", "usp_fearp"}
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

  defp uni_badge(%{source: :usp_fearp} = assigns) do
    ~H"""
    <div class="badge badge-secundary">USP-FEARP</div>
    """
  end

  defp views_badge(%{views: views} = assigns) do
    ~H"""
    <div class="badge badge-secundary">{views}</div>
    """
  end

  def format_title(title) do
    if String.length(title) > 50 do
      String.slice(title, 0..50) <> "..."
    else
      title
    end
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          payload: %Ash.Notifier.Notification{data: %{views: views, id: id}}
        },
        socket
      ) do
    {:noreply,
     update_if_visible(socket, "internships-collection", id, fn internship ->
       %{internship | views: views}
     end)}
  end
end

defmodule BuscaEstagio.Internships.Internship do
  use Ash.Resource,
    otp_app: :busca_estagio,
    domain: BuscaEstagio.Internships,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  postgres do
    table "internships"
    repo BuscaEstagio.Repo
  end

  actions do
    defaults [:destroy, :update]
    default_accept [:id, :title, :description, :source]

    read :read do
      primary? true
      pagination required?: true, offset?: true, keyset?: true
    end

    read :by_id do
      get? true
      argument :id, :uuid, public?: true

      filter expr(id == ^arg(:id))
    end

    update :increment_views do
      accept []
      change atomic_update(:views, expr(views + 1))
    end

    create :create do
      primary? true
      accept [:title, :source, :url]

      argument :description_html, :string do
        allow_nil? false
      end

      change BuscaEstagio.Internships.Changes.GenerateDescription
    end
  end

  pub_sub do
    module BuscaEstagioWeb.Endpoint

    prefix "internship"
    publish :increment_views, ["viewed"]
  end

  preparations do
    prepare build(load: [:description_preview, :is_new?])
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :title, :string do
      public? true
      allow_nil? false
    end

    attribute :description, :string do
      public? true
      allow_nil? false
    end

    attribute :source, :atom do
      public? true
      allow_nil? false
      constraints one_of: [:usp_eesc, :ufmg_icex, :usp_icmc, :usp_fearp]
    end

    attribute :views, :integer do
      public? true
      allow_nil? false
      default 0
    end

    attribute :url, :string do
      public? true
      allow_nil? false
    end

    timestamps()
  end

  calculations do
    calculate :is_new?,
              :boolean,
              expr(inserted_at > ^DateTime.add(DateTime.utc_now(), -7 * 24 * 60 * 60))

    calculate :description_preview,
              :string,
              expr(
                fragment(
                  "substring(? from 1 for 200)",
                  description
                )
              )
  end

  identities do
    identity :unique_url, [:url]
  end
end

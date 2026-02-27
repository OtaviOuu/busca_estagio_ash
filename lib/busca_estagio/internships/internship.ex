defmodule BuscaEstagio.Internships.Internship do
  use Ash.Resource,
    otp_app: :busca_estagio,
    domain: BuscaEstagio.Internships,
    data_layer: AshPostgres.DataLayer

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

    create :create do
      primary? true
      accept [:title, :source]

      argument :description_html, :string do
        allow_nil? false
      end

      change BuscaEstagio.Internships.Changes.GenerateDescription
    end
  end

  preparations do
    prepare build(load: [:description_preview])
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
      constraints one_of: [:usp_eesc, :ufmg_icex, :usp_icmc]
    end

    timestamps()
  end

  calculations do
    calculate :description_preview,
              :string,
              expr(
                fragment(
                  "substring(? from 1 for 200)",
                  description
                )
              )
  end
end

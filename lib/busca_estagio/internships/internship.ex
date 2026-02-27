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
    defaults [:read, :destroy]

    create :create do
      accept [:title]

      argument :description_html, :string do
        allow_nil? false
      end

      change BuscaEstagio.Internships.Changes.GenerateDescription
    end
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

    timestamps()
  end
end

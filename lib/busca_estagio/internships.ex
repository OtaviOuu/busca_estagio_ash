defmodule BuscaEstagio.Internships do
  use Ash.Domain,
    otp_app: :busca_estagio,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource BuscaEstagio.Internships.Internship do
      define :create_internship, action: :create
      define :list_internships, action: :read
      define :get_internship, action: :by_id, args: [:id]
      define :view_internship, action: :increment_views
    end
  end
end

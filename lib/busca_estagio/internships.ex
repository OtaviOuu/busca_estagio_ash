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
    end
  end
end

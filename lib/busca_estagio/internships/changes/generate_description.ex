defmodule BuscaEstagio.Internships.Changes.GenerateDescription do
  use Ash.Resource.Change

  def change(changeset, _opts, _ctx) do
    description_html = Ash.Changeset.get_argument(changeset, :description_html)

    Ash.Changeset.change_attribute(
      changeset,
      :description,
      String.slice(description_html, 3..4)
    )
  end
end

defmodule BuscaEstagio.Internships.Changes.GenerateDescription do
  use Ash.Resource.Change
  require Logger

  @model "groq:openai/gpt-oss-120b"

  def change(changeset, _opts, _ctx) do
    Logger.info(
      "Generating description for internship with title: #{Ash.Changeset.get_argument(changeset, :title)}"
    )

    description_html = Ash.Changeset.get_argument(changeset, :description_html)

    Ash.Changeset.change_attribute(
      changeset,
      :description,
      generate_description_from_html(description_html)
    )
  end

  defp generate_description_from_html(description_html) do
    system_prompt = """
    you are a helpful assistant that generates internship descriptions based on HTML input

    dont use emojis in the description

    """

    user_prompt = """
    Generate a formatted internship description from the following HTML. Return only text. this text will be inserted in a html page, so you can use basic html tags like <p>, <ul>, <li>, <br> to format the description, but avoid using complex tags like <div> or <span>.:

    #{description_html}
    """

    ReqLLM.generate_text!(
      @model,
      ReqLLM.Context.new([
        ReqLLM.Context.system(system_prompt),
        ReqLLM.Context.user(user_prompt)
      ]),
      temperature: 0.7,
      max_tokens: 2000,
      api_key: groq_api_key()
    )
  end

  defp groq_api_key do
    Application.fetch_env!(:busca_estagio, :groq_api_key)
  end
end

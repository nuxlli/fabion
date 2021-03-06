defmodule Ohno.Factories do
  use ExMachina.Ecto, repo: Ohno.Repo

  import Ohno.Support.Helpers
  import ShorterMaps

  alias Ohno.Sources
  alias Ohno.Accounts
  alias Ohno.Builder

  def repository_factory do
    github_repo = Faker.Internet.user_name() <> "/" <> Faker.Internet.domain_word()

    gcloud = Slug.slugify("github-" <> github_repo, separator: ?-)

    %Sources.Repository{
      gcloud_repo: gcloud,
      gcloud_project_id: gcloud,
      github_repo: github_repo,
      github_secret: Ecto.UUID.generate(),
      github_token: Ecto.UUID.generate()
    }
  end

  def github_user_factory do
    user_id = Faker.random_between(1, 5000)

    %Accounts.GithubUser{
      node_id: Base.encode64("04:User#{user_id}"),
      login: Faker.Internet.user_name(),
      html_url: Faker.Internet.url(),
      avatar_url: Faker.Internet.url()
    }
  end

  def pipeline_factory do
    %Builder.Pipeline{
      from_type: :PUSH_EVENT,
      params: %{},
      repository: build(:repository),
      sender: build(:github_user),
      stages_groups: [
        "test",
        "release",
        "deploy"
      ]
    }
  end

  def pipeline_with_params(from_type, file) do
    params = read_file_event!(file)

    {:ok, github_repo} =
      jq!(params, ".repository.url")
      |> Sources.parse_repo()

    repository = build(:repository, ~M{github_repo})
    insert(:pipeline, ~M{from_type, params, repository})
  end

  def stage_factory do
    %Builder.Stage{
      name: "test",
      stage_group: "test",
      config_file: "./buildcloud.yaml",
      cloudbuild: %{},
      config: %{},
      pipeline: build(:pipeline)
    }
  end

  def job_factory do
    %Builder.Job{
      stage: build(:stage),
      gcloud_build_id: Ecto.UUID.generate()
    }
  end
end

defmodule Fabion.SourcesTest do
  use Fabion.DataCase, async: true

  import Mox
  alias Fabion.Sources

  test "update status with adapter" do
    Fabion.MockSourcesAdapter
      |> expect(:client, 1, fn -> :client end)
      |> expect(:statuses, 1, fn
        :client, repo, sha, params -> {:ok, ~M{repo, sha, params}}
      end)

    params = %{ state: "success" }
    repo   = "nuxlli/fabion"
    sha    = "commit_sha"
    {:ok, %{params: ^params, repo: ^repo, sha: ^sha}} = Sources.statuses(repo, sha, params)
  end
end

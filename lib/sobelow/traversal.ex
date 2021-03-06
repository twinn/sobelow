defmodule Sobelow.Traversal do
  @moduledoc """
  # Path Traversal

  Path traversal vulnerabilities are a result of
  interacting with the filesystem using untrusted input.
  This class of vulnerability may result in file disclosure,
  code execution, denial of service, and other issues.

  Read more about Path Traversal here:
  https://www.owasp.org/index.php/Path_Traversal

  Path Traversal checks can be ignored with the following command:

      $ mix sobelow -i Traversal
  """
  @submodules [Sobelow.Traversal.SendFile,
               Sobelow.Traversal.FileModule]

  use Sobelow.Finding

  def get_vulns(fun, filename, web_root) do
    filename = String.replace_prefix(filename, "/", "")
    path = web_root <> String.replace_prefix(filename, "web/", "")
    |> Path.expand("")
    |> String.replace_prefix("/", "")
    allowed = @submodules -- Sobelow.get_ignored()

    Enum.each allowed, fn mod ->
      apply(mod, :run, [fun, path])
    end
  end
end
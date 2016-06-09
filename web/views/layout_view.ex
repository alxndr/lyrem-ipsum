defmodule LyremIpsum.LayoutView do
  use LyremIpsum.Web, :view

  def title, do: "Lyrem Ipsum"
  def title(artist) do
    "lyrics by #{artist}"
  end

end

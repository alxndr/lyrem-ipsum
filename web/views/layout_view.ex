defmodule LyremIpsum.LayoutView do
  use LyremIpsum.Web, :view

  def title(assigns) do
    artist = assigns.conn.assigns.artist
    "lyrics by #{artist}"
  end

end

defmodule Identicon.Image do
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
# structs enforce that only the data properties defined in the module can be defined on the map
defmodule Identicon do
  def main(input) do
    hash_input(input)
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    %Identicon.Image{ hex: hex }
  end

  # pattern matching uses the "| _tail" phrase to define a unspecified number of trailing values in a List that should be ignored
  def pick_color(%Identicon.Image{ hex: [r, g, b | _tail] } = image) do
    # alternate way of defining hex_list and retrieving first three values using Enum.slice instead of pattern matching
    # %Identicon.Image{ hex: hex_list } = image
    # [r, g, b] = Enum.slice(hex_list, 0, 3)
    # update using Map.put
    # Map.put(image, :color, [r, g, b])
    # update of struct using pattern matching. Better here because key exists
    %Identicon.Image{ image | color: { r, g, b } }
  end

  def mirror_row(row) do
    # approach not using pattern matching
    # value = Enum.slice(row, 0, length(row) - 1)
    # Enum.concat(row, Enum.reverse(value))
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def build_grid(%Identicon.Image{ hex: hex } = image) do
    # approach using a for loop
    # rows = for row <- Enum.chunk(hex, 3) do
     # mirror_row(row)
    # end
    grid = Enum.chunk(hex, 3)
    |> Enum.map(&mirror_row/1) # use & symbol to declare that a function reference is being passed followed by the function name and then /x where x is arity of the function
    |> List.flatten
    |> Enum.with_index
    %Identicon.Image{ image | grid: grid }
  end
  
  def filter_odd_squares(%Identicon.Image{ grid: grid } = image) do
    filtered = Enum.filter(grid, fn({ code, _index }) -> 
      rem(code, 2) === 0 
    end)
    %Identicon.Image{ image | grid: filtered }
  end

  def build_pixel_map(%Identicon.Image{ grid: grid } = image) do
    pixel_map = Enum.map(grid, fn({ _code, index }) -> 
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = { horizontal, vertical }
      bottom_right = { horizontal + 50, vertical + 50 }
      { top_left, bottom_right }
    end)
    %Identicon.Image{ image | pixel_map: pixel_map }
  end
  # in pattern matching assignments for arguments you only need to set the matching value if you need a reference to the value itself ie. "= image" in previous functions
  def draw_image(%Identicon.Image{ color: color, pixel_map: pixel_map }) do
    # this call creates a rectangular template which can be drawn upon
    image = :egd.create(250, 250)
    # creates a egd template compatible color using RBG
    fill = :egd.color(color)
    Enum.each(pixel_map, fn({ start, stop }) ->
      # draws a block of a given color to egd template
      # image = template, start = top left coordinates, stop = bottom right coordinates, fill = egd color
      # unlike most functions this modifies the image value itself without returning a new instance
      :egd.filledRectangle(image, start, stop, fill)
    end)
    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{ input }.png", image)
  end
end

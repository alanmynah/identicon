defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Creates a grid similar to github identicon.

  MD5 hashes the name, first 15 values are then arranged in a 25-cell grid
  (10 values on the left are mirrored along the central 5 values),
  like so:

  |1 |2 |3 |2 |1 |
  |4 |5 |6 |5 |4 |
  |7 |8 |9 |8 |7 |
  |10|11|12|11|10|
  |13|14|15|14|13|

  If a value is even - coloured cell, odd - blank cell.
  And to make it pretty, the first 3 values are used to get RGB colours

  ## Examples

  """

  def main(input) do
    input
    |> create_image_from_string()
    |> build_grid()
    |> filter_out_odd_squares()
    |> build_pixel_map()
    |> draw_image()
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_grid_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_out_odd_squares(%Identicon.Image{grid: grid} = image) do
    filtered_grid =
      Enum.filter(grid, fn {hex_code, _index} ->
        rem(hex_code, 2) == 0
      end)

    %Identicon.Image{image | grid: filtered_grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_rows/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_rows(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  def create_image_from_string(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list()
    [r, g, b | _tail] = hex

    %Identicon.Image{hex: hex, color: {r, g, b}}
  end
end

defmodule GE.View.Helpers do

  def num(num), do:
    Number.Delimit.number_to_delimited(num, delimiter: " ")

  def apply_discount(amount, discount),
      do: Float.round(amount * (100 - discount) / 100, 2)

  def date(date), do:
    Timex.format!(date, "%d %b %Y %H:%M", :strftime)

  def ava_text(string), do:

    string
    |> String.first()
    |> String.capitalize()

end
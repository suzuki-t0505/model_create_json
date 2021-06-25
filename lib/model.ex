defmodule Model do
  # def objfile_read(filename) do
  #   [read | deta] = File.read!(filename)
  #     |> String.split("\r\nv")

  #   objdeta = Enum.map(deta, &String.split(&1, " "))
  # end

  def gtsfile_read(filename) do
    [deta | mdeta] =
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&Enum.filter(&1, fn n -> n != "" end))
    |> Enum.map(& if Enum.empty?(&1) == false do &1 end)
    |> Enum.filter(& &1)
    #|> Enum.map(&Enum.map(&1, fn num -> String.to_float(num) end))
    #取り出すのはEnum.take(mdeta,Enum.at(deta, 0))
    #integerに変換
    deta = Enum.map(deta, &String.to_integer(&1))
    #floatに変換
    mdeta =
    Enum.map(mdeta, &Enum.map(&1, fn n -> n <> ".0" end))
    |> Enum.map(&Enum.map(&1, fn num -> String.to_float(num) end))

    vertex =
    Enum.take(mdeta, Enum.at(deta, 0))
    |> Enum.map(&Enum.zip([:x, :y, :z], &1))

    line_segment =
    Enum.drop(mdeta, Enum.at(deta, 0))
    |> Enum.take(Enum.at(deta, 1))
    |> Enum.map(&Enum.zip([:startpoint, :endpoint], &1))

    triangle =
    Enum.drop(mdeta, Enum.at(deta, 0) + Enum.at(deta, 1))
    |> Enum.take(Enum.at(deta, 2))
    |> Enum.map(&Enum.zip([:first, :second, :thred],&1))

    model_deta =
    vertex ++ line_segment ++ triangle
    |> Enum.map(&Enum.into(&1, %{}))
    |> Poison.encode!

    filewiret("model.json", model_deta)
  end

  def filewiret(filename, deta) do
    File.write(filename, deta)
  end
end

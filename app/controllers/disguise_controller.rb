class DisguiseController < ApplicationController
  layout "disguise"

  TEMPLATES = {
    "Calculator" => "disguise/calculator",
    "Weather" => "disguise/weather",
    "Tile game" => "disguise/tile_game",
    "Sports" => "disguise/sports"
  }.freeze

  def show
    @disguise = Setting.instance.disguise
    @skin_accent = Setting.instance.disguise_accent.presence
    render TEMPLATES.fetch(@disguise, "disguise/weather")
  end
end

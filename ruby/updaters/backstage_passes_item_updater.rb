require_relative 'item_updater'

module Updaters
  class BackstagePassesItemUpdater < ItemUpdater
    def update
      sell_in = item.sell_in
      quality = if (6..10).cover?(sell_in)
                  2
                elsif (1..5).cover?(sell_in)
                  3
                elsif sell_in.zero?
                  return item.quality = 0
                else
                  1
                end

      item.quality += quality
    end
  end
end

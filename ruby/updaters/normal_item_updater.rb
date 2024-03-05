require_relative 'item_updater'

module Updaters
  class NormalItemUpdater < ItemUpdater
    def update
      if item.sell_in > 0
        item.quality -= 1
      else
        item.quality -= 2
      end
    end
  end
end

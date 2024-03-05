require_relative 'item_updater'

module Updaters
  class ConjuredItemUpdater < ItemUpdater
    def update
      item.quality -= 2
    end
  end
end

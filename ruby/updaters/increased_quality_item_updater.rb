require_relative 'item_updater'

module Updaters
  class IncreasedQualityItemUpdater < ItemUpdater
    def update
      item.quality += 1
    end
  end
end

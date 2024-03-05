module Updaters
  class ItemUpdater
    def initialize(item)
      @item = item
    end
    
    def update; end
    
    private
    
    attr_reader :item
  end
end

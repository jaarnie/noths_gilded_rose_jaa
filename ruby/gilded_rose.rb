require 'bundler/setup'
Bundler.require

require_relative 'updaters/normal_item_updater'
require_relative 'updaters/backstage_passes_item_updater'
require_relative 'updaters/increased_quality_item_updater'
require_relative 'updaters/conjured_item_updater'

class GildedRose
  LEGENDARY_ITEMS = ["Sulfuras, Hand of Ragnaros"]
  INCREASE_QUALITY_ITEMS = ["Aged Brie"]


  def initialize(items)
    @items = Array(items)
  end

  def update_quality
    @items.each do |item|
      next unless item.quality.positive? && item.quality <= 50

      updater = if legendary_item?(item)
                  next
                elsif backstage_passes?(item)
                  Updaters::BackstagePassesItemUpdater.new(item)
                elsif increased_quality_item?(item)
                  Updaters::IncreasedQualityItemUpdater.new(item)
                elsif conjured_item?(item)
                  Updaters::ConjuredItemUpdater.new(item)
                else
                  Updaters::NormalItemUpdater.new(item)
                end

      updater.update
      item.sell_in -= 1
    end
  end

  private

  def normal_item?(item)
    !backstage_passes?(item) &&
    !increased_quality_item?(item) && 
    !legendary_item?(item) && 
    !conjured_item?(item)
  end

  def backstage_passes?(item)
    item.name.downcase.start_with?("backstage passes")
  end

  def increased_quality_item?(item)
    INCREASE_QUALITY_ITEMS.include?(item.name)
  end
  
  def legendary_item?(item)
    LEGENDARY_ITEMS.include?(item.name)
  end

  def conjured_item?(item)
    item.name.downcase.start_with?("conjured")
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

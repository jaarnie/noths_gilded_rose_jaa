require 'bundler/setup'
Bundler.require

class GildedRose
  LEGENDARY_ITEMS = ["Sulfuras, Hand of Ragnaros"]
  INCREASE_QUALITY_ITEMS = ["Aged Brie"]


  def initialize(items)
    @items = Array(items)
  end

  def update_quality
    @items.each do |item|
      next unless item.quality.positive? && item.quality <= 50

      if normal_item?(item)
        update_normal_item(item)
      end

      if backstage_passes?(item) && item.quality < 50
        update_backstage_passes_item(item)
      end

      if increased_quality_item?(item) && item.quality < 50
        item.quality += 1
      end

      if legendary_item?(item)
        next
      end

      if conjured_item?(item)
        item.quality -= 2
      end

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

  def update_normal_item(item)
    if item.sell_in > 0
      item.quality -= 1
    else
      item.quality -= 2
    end
  end
  
  def update_backstage_passes_item(item)
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

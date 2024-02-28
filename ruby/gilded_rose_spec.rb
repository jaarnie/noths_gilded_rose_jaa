require File.join(File.dirname(__FILE__), 'gilded_rose')

  # Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
  # Item.new(name="Aged Brie", sell_in=2, quality=0),
  # Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
  # Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
  # Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
  # Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
  # Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
  # Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
  # Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O

RSpec.describe GildedRose do
  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("Leeroy Jenkins' battlecry", 0, 0)]
      GildedRose.new(items).update_quality

      expect(items[0].name).to eq "Leeroy Jenkins' battlecry"
    end

    context "when non-legendary/special items" do
      it "decreases quality by 1" do
        items = [Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)]

        expect do
          GildedRose.new(items).update_quality
        end.to change { items[0].quality }.by(-1)
      end
    end

    context "when the sell by date has passed for non-legendary/special items" do
      it "decreases quality twice as fast" do
        items = [Item.new(name="Elixir of the Mongoose", sell_in=0, quality=7)]

        expect do
          GildedRose.new(items).update_quality
        end.to change { items[0].quality }.by(-2)
      end
    end

    context "when legendary item" do
      it "does not change quality" do
        items = [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=1, quality=80)]

        expect do
          GildedRose.new(items).update_quality
        end.to_not change { items[0].quality }
      end
    end

    context "when aged brie" do
      it "increases quality as it gets older" do
        items = [Item.new(name="Aged Brie", sell_in=2, quality=10)]

        expect do
          GildedRose.new(items).update_quality
        end.to change { items[0].quality }.by(1).and change { items[0].sell_in }.by(-1)
      end
    end

    context "when backstage passes" do
      let(:items) do 
        [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in, quality=20)]
      end

      context "when more than 10 days before the concert" do
        let(:sell_in) { 15 }

        it "increases quality by 1" do
          expect do
            GildedRose.new(items).update_quality
          end.to change { items[0].quality }.by(1).and change { items[0].sell_in }.by(-1)
        end
      end

      context "when 10 days or less before the concert" do
        let(:sell_in) { 10 }

        it "increases quality by 2" do
          expect do
            GildedRose.new(items).update_quality
          end.to change { items[0].quality }.by(2).and change { items[0].sell_in }.by(-1)
        end
      end

      context "when 5 days or less before the concert" do
        let(:sell_in) { 5 }

        it "increases quality by 3" do
          expect do
            GildedRose.new(items).update_quality
          end.to change { items[0].quality }.by(3).and change { items[0].sell_in }.by(-1)
        end
      end

      context "when the concert has passed" do
        let(:sell_in) { 0 }

        it "decreases quality to 0" do
          expect do
            GildedRose.new(items).update_quality
          end.to change { items[0].quality }.to(0)
        end
      end
    end

    context "when quality is at 0" do
      it "does not update the item" do
        items = [Item.new(name="foo", sell_in=2, quality=0)]

        expect do
          GildedRose.new(items).update_quality
        end.to_not change { [items[0].quality, items[0].sell_in] }
      end
    end

    context "when counjured items" do
      xit "decreases quality twice as fast" do
        items = [Item.new(name="Conjured Mana Cake", sell_in=3, quality=6)]

        expect do
          GildedRose.new(items).update_quality
        end.to change { items[0].quality }.by(-2)
      end
    end
  end
end

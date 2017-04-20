require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  describe '#balance' do
    it 'Should return 0 balance' do
      expect(oystercard.balance).to eq(0)
  end

  describe '#top_up' do
    it 'Expects #top_up to change balance' do
    expect { oystercard.top_up(10) }.to change { oystercard.balance }.by(10)
    end

    it 'Should raise error if top up breaches limit' do
      max_balance = Oystercard::MAX_BALANCE
      oystercard.top_up(max_balance)
      expect { oystercard.top_up(1) }.to raise_error "Top-up over max balance £#{max_balance}"
    end
  end

  describe '#touch_in' do
    xit 'changes #in_journey? to true' do
      oystercard.top_up(20)
      expect { oystercard.touch_in }.to change { oystercard.in_journey? }.to true
    end
    xit '#touch_in when already travelling raises error' do
      oystercard.top_up(10)
      oystercard.touch_in
      expect { oystercard.touch_in }.to raise_error 'Already travelling'
    end
      context 'low_balance' do
         xit 'Raises an error' do
          low_balance = Oystercard::LOW_BALANCE
          oystercard.top_up(low_balance - 1)
          expect { oystercard.touch_in }.to raise_error 'Not enough funds'
        end
      end
  end

  describe '#touch_out' do
    xit 'changes #in_journey to false' do
      oystercard.top_up(10)
      oystercard.touch_in
      expect { oystercard.touch_out }.to change { oystercard.in_journey? }.to false
    end
    it 'raises error if touch_out when not in journey' do
      expect { oystercard.touch_out }.to raise_error 'ERROR! Not travelling!'
    end
      context "change balance" do
        xit "deducts fare" do
          oystercard.top_up(20)
          oystercard.touch_in
          expect { oystercard.touch_out }.to change {oystercard.balance }.by -2
        end
      end
    end

  describe "#station" do
    let(:entry_station) { double(:entry_station) }
    let(:exit_station) { double(:exit_station) }
      it "stores an instance of Station" do
        oystercard.top_up(10)
        oystercard.touch_in(entry_station)
        expect(oystercard.entry_station).to eq entry_station
      end

      it "resets the entry_station when you touch_out" do
        oystercard.top_up(20)
        oystercard.touch_in(entry_station)
        oystercard.touch_out
        expect(oystercard.entry_station).to be_nil
      end

      it { is_expected.to respond_to :all_stations }

      it "should displayed us all the previous stations" do
        oystercard.top_up(20)
        oystercard.touch_in(entry_station)
        oystercard.touch_out
        expect(oystercard.all_stations).to eq [entry_station]
      end

      it "should display a complete journey" do
        oystercard.top_up(20)
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.all_stations).to eq [entry_station, exit_station]
      end

    end
end

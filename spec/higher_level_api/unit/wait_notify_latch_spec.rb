require "spec_helper"
require "bunny/wait_notify_latch"

describe Bunny::WaitNotifyLatch do
  describe "#wait" do
    subject do
      described_class.new
    end

    it "blocks current thread until notified" do
      xs = []

      t = Thread.new do
        xs << :notified

        sleep 0.25
        subject.notify
      end

      subject.wait
      xs.should == [:notified]
    end
  end

  describe "#notify" do
    it "notifies a single thread waiting on the latch" do
      xs = []

      t1 = Thread.new do
        subject.wait
        xs << :notified1
      end

      t2 = Thread.new do
        subject.wait
        xs << :notified2
      end

      sleep 0.25
      subject.notify
      sleep 0.5
      xs.should == [:notified1]
    end
  end

  describe "#notify_all" do
    it "notifies all the threads waiting on the latch" do
      xs = []

      t1 = Thread.new do
        subject.wait
        xs << :notified1
      end

      t2 = Thread.new do
        subject.wait
        xs << :notified2
      end

      sleep 0.25
      subject.notify_all
      sleep 0.5
      xs.should include(:notified1)
      xs.should include(:notified2)
    end
  end
end

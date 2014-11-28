require 'spec_helper'

describe Spree::Video do
  before { @video = FactoryGirl.create(:video) }
  let(:video) { @video }

  it "should handle different youtube strings" do
    video.youtube_ref = "http://www.youtube.com/watch?v=9t0n5MD9SBU"
    video.save
    expect(video.reload.youtube_ref).to eq "9t0n5MD9SBU"

    video.update_attributes :youtube_ref => 'iJ4T9CQA0UM'
    expect(video.reload.youtube_ref).to eq 'iJ4T9CQA0UM'

    video.update_attributes :youtube_ref => 'http://youtu.be/9xtn36e2shw'
    expect(video.reload.youtube_ref).to eq '9xtn36e2shw'

    video.update_attributes :youtube_ref => 'http://www.youtube.com/watch?v=M6Ctprmv-cs&feature=player_embedded'
    expect(video.reload.youtube_ref).to eq 'M6Ctprmv-cs'

    video.update_attributes :youtube_ref => 'http://www.youtube.com/watch?feature=player_embedded&v=M6Ctprmv-cs'
    expect(video.reload.youtube_ref).to eq 'M6Ctprmv-cs'
  end

  it "should not allow two of same videos attached to a product" do
    expect{ FactoryGirl.create :video, :watchable => video.watchable }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
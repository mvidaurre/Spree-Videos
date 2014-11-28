require 'spec_helper'

describe 'video display', type: :feature, js: true do
  before do 
    @product = create :product, :name => "The Product"
  end
  let(:product) { @product }

  it "should display no video player when no videos exist" do
    visit spree.product_path(product)
    expect(page).to_not have_css('#product-videos')
  end

  it "should display a single video without thumbnails on a product page" do
    v = product.videos.build
    v.youtube_ref = 'iJ4T9CQA0UM'
    v.save!

    visit spree.product_path(product)

    expect(page).to have_css('#product-videos')
    expect(page).to have_css('#video-player')
    expect(page).to_not have_css('#video-thumbnails')
  end

  it "should display a player with multiple thumbnails when multiple thumbnails exist" do
    v = product.videos.build
    v.youtube_ref = 'iJ4T9CQA0UM'
    v.save!

    v = product.videos.build
    v.youtube_ref = 'reMzODLo80Q'
    v.save!

    visit spree.product_path(product)

    expect(page).to have_css('#product-videos')
    expect(page).to have_css('#video-player')
    expect(page).to have_css('#video-thumbnails')
  end
end
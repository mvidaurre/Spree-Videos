require 'spec_helper'

describe 'admin functionality', type: :feature, js: true do
  stub_authorization!

  before do 
    @product = create :product, :name => "The Product"
  end
  let(:product) { @product }

  it "should list videos associated with a product" do

  end

  it "should properly add a video to a " do
    visit spree.new_admin_product_video_path(product)
    fill_in 'video_youtube_ref', :with => '0IJoKuTlvuM'
    click_button 'Update'

    expect(page).to have_content('Video has been successfully created!')
    expect(page).to have_content('0IJoKuTlvuM')
  end
end
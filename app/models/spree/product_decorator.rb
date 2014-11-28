Spree::Product.class_eval do
  has_many :videos, -> { order(position: :asc) }, :as => :watchable
end
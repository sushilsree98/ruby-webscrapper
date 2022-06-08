class Scrap
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :title, type: String
  field :description, type: String
  field :price, type: String
end

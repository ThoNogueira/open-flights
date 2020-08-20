class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :descriptions, :score, :airline_id
end

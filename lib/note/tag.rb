require 'dynamoid'

module Note
  class Tag
    include Dynamoid::Document

    table(
      :name => :tags,
      :key => :id,
      :read_capacity => 1,
      :write_capacity => 1,
    )

    field :name, :string

    belongs_to :note
  end
end

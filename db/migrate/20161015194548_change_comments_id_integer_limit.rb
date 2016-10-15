class ChangeCommentsIdIntegerLimit < ActiveRecord::Migration[5.0]
  def change
    change_column :comments, :id, :integer, limit: 8
  end
end

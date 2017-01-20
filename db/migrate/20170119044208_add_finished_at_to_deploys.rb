# frozen_string_literal: true
class AddFinishedAtToDeploys < ActiveRecord::Migration[5.0]
  def change
    remove_column :deploys, :finished_at, :datetime
    remove_column :deploys, :started_at, :datetime
  end
end

# frozen_string_literal: true
class AddFinishedAtToDeploys < ActiveRecord::Migration[5.0]
  class Deploy < ActiveRecord::Base
  end

  def change
    add_column :deploys, :finished_at, :datetime
    Deploy.update_all('finished_at = updated_at')
  end
end

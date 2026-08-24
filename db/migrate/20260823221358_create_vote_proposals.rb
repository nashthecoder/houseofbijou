class CreateVoteProposals < ActiveRecord::Migration[8.1]
  def change
    create_table :vote_proposals do |t|
      t.string :title
      t.integer :supports_count

      t.timestamps
    end
  end
end

class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.string :title, null: false
      t.string :color, default: "#c29765"
      t.integer :position, default: 0

      t.timestamps
    end

    add_reference :messages, :conversation, foreign_key: true
    add_column :messages, :expires_at, :datetime

    reversible do |dir|
      dir.up do
        circle = Conversation.create!(title: "Circle check-ins", color: "#a9bd7e", position: 1)
        mumbi = Conversation.create!(title: "Mumbi", color: "#c29765", position: 2)
        ash = Conversation.create!(title: "Ash", color: "#8a9a5b", position: 3)

        Message.update_all(conversation_id: mumbi.id) # rubocop:disable Rails/SkipsModelValidations
        Message.create!(conversation: circle, sender: "them", body: "Circle check-in: everyone safe this week?", created_at: 26.hours.ago)
        Message.create!(conversation: circle, sender: "you", body: "Safe and home.", created_at: 25.hours.ago)
        Message.create!(conversation: circle, sender: "them", body: "Glad to hear it ❤️", created_at: 24.hours.ago)
        Message.create!(conversation: ash, sender: "them", body: "Water is back on my side. You?", created_at: 5.hours.ago)
      end
    end

    change_column_null :messages, :conversation_id, false
  end
end

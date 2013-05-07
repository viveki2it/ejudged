class CreateJudgeSheets < ActiveRecord::Migration
  def change
    create_table :judge_sheets do |t|
      t.string :Name

      t.timestamps
    end
  end
end

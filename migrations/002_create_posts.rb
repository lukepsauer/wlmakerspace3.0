Sequel.migration do
  up do
    create_table(:posts) do
      primary_key :id

      String :title
      String :url
      String :content
      Time :date
      String :type
      Integer :draft


    end
  end

  down do
    drop_table(:posts)
  end
end
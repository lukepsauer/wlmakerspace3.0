Sequel.migration do
  up do
    create_table(:posts) do
      primary_key :id

      String :title
      String :url
      String :content
      String :content_raw
      Date :date
      String :type
      Integer :draft
      Integer :author
    end
  end

  down do
    drop_table(:posts)
  end
end
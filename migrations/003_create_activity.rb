Sequel.migration do
  up do
    create_table(:posts) do
      primary_key :id

      String :title
      String :img_url
      String :content
      String :content_raw

    end
  end

  down do
    drop_table(:posts)
  end
end
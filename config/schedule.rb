every 1.minute do
  rake 'message:delete_expired'
end

#delete cached checkins
CachedCheckin.destroy_all(["created_at < ?",  1.day.ago])
FriendCheckin.destroy_all(["created_at < ?",  1.day.ago])
CachedFriend.destroy_all(["created_at < ?",  1.day.ago])
  
#delete votes
#Vote.destroy_all(["created_at < ?",  60.days.ago])
  
#delete power changes
#PowerChange.destroy_all(["created_at < ?",  60.days.ago])

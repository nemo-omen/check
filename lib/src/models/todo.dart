// todo:
// * Pages
// * |—> Home
// * |———> Check Stream
// * |       |___ListView()
// * |           |___ Sorting (default: newest first | option: oldest | option: almost time | option: late)
// * |              |___ if(DateTime.now - lastCheckedDateTime == 24hrs) {showNagButton();}
// * |—> Friends
// * |     |___ListView
// * |          |___ Card()
// * |             |  |___ onClick((friends[index]){showFriend(friend[index])})
// * |             |___ Card()
// * |             |      |___ CircularAvatar()
// * |             |      |___ Container()
// * |             |      |___ ListView([friend.name, friend.homeLocation, friend.lastCheckDateTime, friend.currentCheckLevel])
// * |             |___ ListView([friend.checks])
// * |
// * |—> Messages
// * |
// * |
// * |—> Notifications
// * |
// * |
// * |—> Search
// * |
// * |—> Profile

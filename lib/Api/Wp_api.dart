String baseUrl = "https://allnewsatfingertips.com/wp-json/wp/v2";
const String OSAppID = "45d927d5-38bb-476c-a708-f7e1bd21ee36";
final categories = [0, 1, 3, 4, 6, 7, 499, 524, 5, 2212];
final cat = [
  "For You",
  "Latest",
  "World",
  "India",
  "Sports",
  "Technology",
  "Entertainment",
  "Business",
  "Astrology",
  "Health & Lifestyle",
];

String getCategory(value) {
  var r = categories.indexOf(value);
  return cat[r];
}

String getDate(String value) {
  var r = value.substring(0, 10);
  return r;
}

// ** Categories ** //
// World - 3
// India - 4
// sports - 6
// Technology - 7
// Entertainment - 499
// Business - 524
// Astrology - 5
// LifeStyle - 2212


// serverKey = AAAArUdM6pM:APA91bEZwR0B6oD8Q5SBtVx1o4aoJpXqf3eCljwiRL72JwJe3ODGCiXpJQag1x33HbYNexzVrA-T6w2Xk7WsfHrBEXDT88Uioo4dMvUf4dAZy2zW4cqb5mESr5YyZXyRBwqIK6QUiZj4
// senderId = 744225565331
// OneSignalAppID = 45d927d5-38bb-476c-a708-f7e1bd21ee36
// AdUnit = ca-app-pub-8831871394978335/3785593651

// Pages - slug
// disclaimer 
// privacy-policy
// contact-us
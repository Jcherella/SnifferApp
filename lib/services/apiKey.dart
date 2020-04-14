
var key = """Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImp0aSI6IjQyZDM4ZTQ0LTEwNmEtNDQzZC05ZDQ3LTIyMmY5ODQwZmNhNCJ9.eyJpc3MiOiJtYWN2ZW5kb3JzIiwiYXVkIjoibWFjdmVuZG9ycyIsImp0aSI6IjQyZDM4ZTQ0LTEwNmEtNDQzZC05ZDQ3LTIyMmY5ODQwZmNhNCIsImlhdCI6MTU4NTU4MzY1MywiZXhwIjoxOTAwMDc5NjUzLCJzdWIiOiI2NTY1IiwidHlwIjoiYWNjZXNzIn0.MiRX-6lrP-GvNWvY4mglnpL3O8MnH3ZlY-rJyJOaJSuP4X6IWYlyXLKR5AnSXlEpItbkFzBYawxPD2EqH0S8Sw""";
//The key is our key. It gives us 1000 requests per day. Clunky but thus far this is the only formatting that works.
//Without spending money this is limiting and in production ready code we'd have various payed keys and encrypt them
//For testing and development that is expensive and unneccesary 
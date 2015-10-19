// hello world demo
Parse.Cloud.define("hello", function(request, response) {
      response.success("Hello world!");
});

// get_circle function
Parse.Cloud.define("get_circle", function(request, response) {
    var _=require("underscore.js");
    var query = new Parse.Query("FriendRelation"); 
    query.equalTo("Username", request.user.get("username"));
    query.find().then(function(results) {
        var result = results[0];
        var friendlist = result.get("friendList");
        return friendlist;
    }, function() {
        response.error("can't find such username");
    }).then(function(friendlist) {
        
        var outer_promises = [];

        var list = [];

        _.each(friendlist, function(each_friend) {
            var each_outer_promise = new Parse.Promise();
            outer_promises.push(each_outer_promise);

            var each_query = new Parse.Query("TurnOnTime");
            each_query.equalTo("user_name", each_friend);

            each_query.find({
                success: function(each_turn_on_results) {
                    var inner_promises = [];

                    _.each(each_turn_on_results, function(each_turn_on_result) {
                        var each_inner_promise = new Parse.Promise();
                        inner_promises.push(each_inner_promise);

                        var most_inner_promises = [];

                        var each_post = {};
                        each_post["objectId"] = each_turn_on_result.id;
                        each_post["name"] = each_friend;
                        each_post["date"] = each_turn_on_result.createdAt;
                        each_post["do_i_like_this_post"] = false;
                        each_post["activity_name"] = each_turn_on_result.get("activity_name");
                        each_post["number_of_likes"] = each_turn_on_result.get("number_of_likes");

                        // like list
                        if (each_turn_on_result.has("likeList")) {
                            var each_like_users_list = each_turn_on_result.get("likeList");
                            if (each_like_users_list.indexOf(request.user.get("username")) != -1)
                                each_post["do_i_like_this_post"] = true;
                        }

                        // comments list
                        var comments_relation = each_turn_on_result.relation("commentsList");
                        var comments_query = comments_relation.query();
                        comments_query.ascending("createdAt");
                        var each_most_inner_comments_promise = new Parse.Promise();
                        most_inner_promises.push(each_most_inner_comments_promise);
                        comments_query.find({
                            success: function(comment_list) {
                                var each_status_comments = [];
                                _.each(comment_list, function(each_comments_list) {
                                    var each_comment = {};
                                    each_comment["username"] = each_comments_list.get("username");
                                    each_comment["content"] = each_comments_list.get("content");
                                    each_status_comments.push(each_comment);
                                });
                                each_post["comments"] = each_status_comments;
                                each_most_inner_comments_promise.resolve("most inner resolved");
                            }
                        });
                    
                        Parse.Promise.when(most_inner_promises).then(function() {
                            list.push(each_post);
                            each_inner_promise.resolve("inner resolved");
                        });
                    });

                    Parse.Promise.when(inner_promises).then(function() {
                        each_outer_promise.resolve("outer promise resolved");
                    });
                }
            });
        });

        url_list = [];

        _.each(friendlist, function(each_friend) {
            var each_promise = new Parse.Promise();
            outer_promises.push(each_promise);

            var each_query = new Parse.Query(Parse.User);
            each_query.equalTo("username", each_friend);
            each_query.first({
                success: function(each_result) {
                    each_url = each_result.get("avatar").url();
                    var each_url_obj = {};
                    each_url_obj["name"] = each_friend;
                    each_url_obj["url"] = each_url;
                    url_list.push(each_url_obj);
                    //console.log(each_url);
                    each_promise.resolve("good result");
                }
            });
        });

        Parse.Promise.when(outer_promises).then(function() {
            for (var i = 0; i < list.length; i++) {
                for (var j = 0; j < url_list.length; j++) {
                    if (list[i]["name"] == url_list[j]["name"]) {
                        list[i]["url"] = url_list[j]["url"];
                        break;
                    }
                }
            }
            list.sort(function(a, b) {
                return new Date(b.date) - new Date(a.date);
            });
            response.success(list);
        });
    });
});

// test TurnOnTime
Parse.Cloud.define("test_turn_on_time", function(request, response) {
    var each_query = new Parse.Query("TurnOnTime");
    each_query.equalTo("user_name", "Derek1");
    each_query.find({
        success: function(each_results) {
            for (i = 0; i < each_results.length; i++) {
                console.log(each_results[i].get("activity_name"));
            }
            response.success("success");
        },
    });
});

// get_contact_avatar_url function
Parse.Cloud.define("get_contact_avatar_url", function(request, response) {
    var _=require("underscore.js");
    var query = new Parse.Query("FriendRelation"); 
    query.equalTo("Username", request.user.get("username"));
    query.find().then(function(results) {
        var result = results[0];
        var friendlist = result.get("friendList");
        return friendlist;
    }, function() {
        response.error("can't find such username");
    }).then(function(friendlist) {

        var promises = [];
        url_list = [];

        _.each(friendlist, function(each_friend) {
            var each_promise = new Parse.Promise();
            promises.push(each_promise);
            var each_query = new Parse.Query(Parse.User);
            each_query.equalTo("username", each_friend);
            each_query.first({
                success: function(each_result) {
                    each_url = each_result.get("avatar").url();
                    var each_url_obj = {};
                    each_url_obj["name"] = each_friend;
                    each_url_obj["url"] = each_url;
                    url_list.push(each_url_obj);
                    each_promise.resolve("good result");
                }
            });
        });

        Parse.Promise.when(promises).then(function() {
            response.success(url_list);
        });
    });
});

// get friendlist
// Parse.Cloud.define("get_friendlist", function(request, response) {
//    var query = new Parse.Query("FriendRelation"); 
//    query.equalTo("Username", request.user.);
//    query.find({
//         success: function(friendlist) {
//                   
//         },
//         error: function() {
//             response.error("can't find such username");
//         }
//    });
// });

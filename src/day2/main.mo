import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Array "mo:base/Array";

import Type "Types";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Bool "mo:base/Bool";

actor class Homework() {
  type Homework = Type.Homework;

  var homeWorkDiary = Buffer.Buffer<Homework>(1);

  // Add a new homework task
  public shared func addHomework(homework : Homework) : async Nat {
    homeWorkDiary.add(homework);
    return homeWorkDiary.size() -1;
  };

  // Get a specific homework task by id
  public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
    if (Nat.greater(homeWorkDiary.size(), id)) {
      return #ok(homeWorkDiary.get(id));
    } else {
      return #err("not implemented");
    };
  };

  // Update a homework task's title, description, and/or due date
  public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
    if (Nat.greater(homeWorkDiary.size(), id)) {
      return #ok(homeWorkDiary.put(id, homework));
    } else {
      return #err("not implemented");
    };
  };

  // Mark a homework task as completed
  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    if (Nat.greater(homeWorkDiary.size(), id)) {
      var homework : Homework = homeWorkDiary.get(id);
      var h : Homework = {
        title = homework.title;
        description = homework.description;
        dueDate = homework.dueDate;
        completed = true;
      };
      return #ok(homeWorkDiary.put(id, h));
    } else {
      return #err("not implemented");
    };
  };

  // Delete a homework task by id
  public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
    if (Nat.greater(homeWorkDiary.size(), id)) {
      let x = homeWorkDiary.remove(id);
      return #ok();
    } else {
      return #err("not implemented");
    };
  };

  // Get the list of all homework tasks
  public shared query func getAllHomework() : async [Homework] {
    return Buffer.toArray(homeWorkDiary);
  };

  // Get the list of pending (not completed) homework tasks
  public shared query func getPendingHomework() : async [Homework] {
    let pending : Buffer.Buffer<Homework> = Buffer.mapFilter<Homework, Homework>(homeWorkDiary, func(x) { if (x.completed) return null else return ?x });
    return Buffer.toArray(pending);
  };

  // Search for homework tasks based on a search terms
  public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    type Pattern = Text.Pattern;
    let pattern : Pattern = #text(searchTerm);
    let matches : Buffer.Buffer<Homework> = Buffer.mapFilter<Homework, Homework>(homeWorkDiary, 
      func(x) {
        var i = Text.split(x.title, pattern);
        var j = Text.split(x.description, pattern);
        var isMatch : Bool = Nat.greater(Iter.size(i), 1) or Nat.greater(Iter.size(j), 1);
        Debug.print(Bool.toText(isMatch));
        if (isMatch) {
          Debug.print("match");
          return ?x
        } else {
          Debug.print("no match");
          return null
        };
      });
    var result = Buffer.Buffer<Homework>(1);
    result.add(matches.get(0));
    return Buffer.toArray(result);
  };
};

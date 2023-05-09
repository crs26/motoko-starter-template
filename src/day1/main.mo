import Float "mo:base/Float";

actor class Calculator() {
  stable var counter: Float = 1;
  
  public func add(x : Float) : async Float {
    counter += x;
    return counter;
  };

  public func sub(x : Float) : async Float{
    counter -= x;
    return counter;
  };

  public func mul(x : Float) : async Float{
    counter *= x;
    return counter;
  };

  public func div(x : Float) : async ?Float{
    if (x == 0) {
      return ?0;
    };
    counter /= x;
    return ?counter;
  };

  public func reset () : async () {
    counter := 0;
  };

  public query func see() : async Float{
    return counter;
  };

  public func power(x : Float) : async Float {
    counter := counter ** x;
    return counter;
  };

  public func sqrt() : async Float{
    return Float.sqrt(counter);
  };

  public func floor() : async Int{
    return Float.toInt(Float.floor(counter));
  }
};
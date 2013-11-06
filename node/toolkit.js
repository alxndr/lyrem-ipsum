/*
 Array#unique
 */
Array.prototype.unique = function() {
  return this.reduce(function(prev_val, current_val) {
    if (prev_val.indexOf(current_val) < 0) {
      prev_val.push(current_val);
    }
    return prev_val;
  }, []);
};

/*
 Array#times_do
 returns an array of n results of calling a callback
 sorta like ruby's Array.new(n) { 'val' }

 ex:
 arr = [5].times_do(function(){ return 'default value';});
 */
Array.prototype.times_do = function(callback) {
  return Array.apply(null, Array(this[0])).map(callback); // todo - add i param to callback
};

/*
  Array#random
 */
Array.prototype.random = function() {
  return this[ Math.floor(Math.random() * this.length) ];
};

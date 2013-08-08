
var assert = require('assert')
  , N = parseInt(process.argv[2], 10)
  , M = parseInt(process.argv[3], 10)

assert(!isNaN(N) && !isNaN(M)   , 'N and M should be numbers')
assert(N >= 1 && N <= 9         , 'N should be between 1 and 9')
assert(M >= 2 && M <= 999999999 , 'M should be between 2 and 999 , 999 , 999')

function getLargestNumFromDigits(digits) {
  assert(!isNaN(digits) && digits > 0, 'digits should be a number bigger than 0')
  return Math.pow(10, digits) - 1
}
assert(getLargestNumFromDigits(3) === 999, 'getLargestNumFromDigits(3) === 999')

var largestNum = getLargestNumFromDigits(N)
  , res = Math.floor(largestNum / M) * M

if (res) {
  console.log('Largest number of %d digits divisible by %d: %d', N, M, res)
} else {
  console.log('No number of %d digits divisible by %d', N, M)
}

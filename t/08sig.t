use Test::Distribution
    tests => 1,
    only  => 'sig';
use Test::More;

# 1 sig + 1 extra
is(Test::Distribution::num_tests(), (-f 'SIGNATURE') ? 2 : 1 , 'number of tests');

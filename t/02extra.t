use Test::Distribution tests => 4;
use Test::More;
ok(1, 'extra test');

# 3 * (1 module) + 4 extra
is(Test::Distribution::num_tests(), 7, 'number of tests');

is_deeply(Test::Distribution::packages(), 'Test::Distribution',
    'packages found');
is_deeply(Test::Distribution::files(), 'blib/lib/Test/Distribution.pm',
    'files found');

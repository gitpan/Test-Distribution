use Test::Distribution
    tests => 1,
    only  => 'podcover',
		podcoveropts => {trustme => [qr/run_tests/]};
use Test::More;

# 1 sig + 1 extra
is(Test::Distribution::num_tests(),2 , 'number of tests');

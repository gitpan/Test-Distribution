use Test::Distribution tests => 4;
use Test::More;
ok(1, 'extra test');

# 4 descriptions + 3 * (1 module) + 4 extra + 1 prereq
my $number_of_tests = 12;
$number_of_tests++ if(-f 'SIGNATURE');

is(Test::Distribution::num_tests(), $number_of_tests, 'number of tests');

is_deeply(Test::Distribution::packages(), 'Test::Distribution',
    'packages found');

my @files = Test::Distribution::files();
# On non Unix type file systems the first file separator could be different than the unix /. The others still seem to be the unix /. Not sure why, but they come from File::Find::Rule, whereas the first comes from File::Spec
like($files[0], qr/blib.*?lib.*?Test.*?Distribution.pm/);


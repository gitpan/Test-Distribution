package Test::Distribution;

use strict;
use warnings;
use File::Find::Rule;
use Test::Pod;
use Test::More;

our $VERSION = '1.02';

sub import {
	return if our $been_here++;
	my $pkg = shift;
	my %args = @_;
	$args{only} ||= [ qw/pod use versions/ ];
	$args{only} = ref $args{only} eq 'ARRAY'
	    ? $args{only} : [ $args{only} ];

	$args{tests} ||= 0;
	run_tests(\%args);
}

sub run_tests {
	my $args = shift;
	my %args = %$args;

	our @files = File::Find::Rule->file()->name('*.pm')->in('blib/lib');
	our @packages = map {
	    (my $x = $_) =~ s|^blib/lib/||;
	    $x =~ s|/|::|g;
	    $x =~ s|\.pm$||;
	    $x } @files;

	my %tests = (
	    pod      => scalar @files,
	    use      => scalar @packages,
	    versions => scalar @packages,
	);

	my %perform = map { $_ => 1 } @{$args{only}};

	# need to use() modules before we can check their $VERSIONS,
	# so we might as well test with use_ok().

	$perform{use} = 1 if $perform{versions};

	our $tests = $args{tests};
	for my $type (keys %perform) {
		die "no such test type: $type\n" unless exists $tests{$type};
		$tests += $tests{$type};
	}

	plan tests => $tests;

	if ($perform{pod}) {
		for my $file (@files) { pod_ok($file) }
	}

	if ($perform{use}) {
		for my $class (@packages) { use_ok($class) }
	}

	if ($perform{versions}) {
		for my $class (@packages) {
			our $version;

			my $this_version = do {
			    no strict 'refs';
			    ${"$class\::VERSION"}
			};

			unless (defined $version) {
				$version = $this_version;
				ok(defined($version),
				    "$class defines a version");
				next;
			}
			is($this_version, $version, "$class version matches");
		}
	}
}

sub packages   { our @packages }
sub files     { our @files }
sub num_tests { our $tests }

1;

__END__

=head1 NAME

Test::Distribution - perform tests on all modules of a distribution

=head1 SYNOPSIS

  $ cat t/01distribution.t
  use Test::Distribution;
  $ make test
  ...

=head1 DESCRIPTION

When using this module in a test script, it goes through all the modules
in your distribution, checks their POD, checks that they compile ok and
checks that they all define the same $VERSION.

It defines its own testing plan, so you usually don't use it in
conjunction with other C<Test::*> modules in the same file. It's
recommended that you just create a one-line test script as shown in the
SYNOPSIS above. However, there are options...

=head1 OPTIONS

On the line in which you C<use()> this module, you can specify named
arguments that influence the testing behavior.

=over 4

=item C<tests =E<gt> NUMBER>

Specifies that in addition to the tests run by this module, your test
script will run additional tests. In other words, this value influences
the test plan. For example:

  use Test::Distribution tests => 1;
  use Test::More;
  is($foo, $bar, 'baz');

It is important that you don't specify a C<tests> argument when
using C<Test::More> or other test modules as the plan is handled by
C<Test::Distribution>.

=item C<only =E<gt> STRING|LIST>

Specifies that only certain sets of tests are to be run. Possible values
are C<pod>, C<use> and C<versions>. For example, if you only want to
run the POD tests, you could say:

  use Test::Distribution only => 'pod';

To specify that you only want to run the POD tests and the C<use> tests,
and also that you are going to run two tests of your own, use:

  use Test::Distribution
    only  => [ qw/pod use/ ],
    tests => 2;

Note that when you specify the C<versions> option, the C<use> option
is automatically added. This is because in order to get a module's
C<$VERSION>, it has to be loaded. In this case we might as well run a
C<use> test.

=back

=head1 EXPOSED INTERNALS

There are a few subroutines to help you see what this module is
doing. Note that these subroutines are neither exported nor exportable,
so you have to call them fully qualified.

=over 4

=item C<Test::Distribution::packages()>

This is a list of packages that have been found. That is, we assume that
each file contains a package of the name indicated by the file's relative
position. For example, a file in C<blib/lib/Foo/Bar.pm> is expected to
be available via C<use Foo::Bar>.

=item C<Test::Distribution::files()>

This is a list of files that tests have been run on. The filenames
are relative to the distribution's root directory, so they start with
C<blib/lib>.

=item C<Test::Distribution::num_tests()>

This is the number of tests that this module has run, based on your
specifications.

=back

=head1 BUGS

If you find any bugs or oddities, please do inform the author.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Distribution Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 VERSION

This document describes version 1.02 of C<Test::Distribution>.

=head1 AUTHOR

Marcel GrE<uuml>nauer <marcel@cpan.org>

=head1 OTHER CREDITS

This module was inspired by a use.perl.org journal entry by brian d foy
(see http://use.perl.org/~brian_d_foy/journal/7463) where he describes
an idea by Andy Lester.

=head1 COPYRIGHT

Copyright 2002 Marcel GrE<uuml>nauer. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Test::More(3pm), Test::Pod(3pm).

=cut


use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Test::Distribution',
    'VERSION_FROM'	=> 'lib/Test/Distribution.pm',
    'PREREQ_PM'		=> {
        Test::More       => 0.45,
        Test::Pod        => 0.95,
        File::Find::Rule => 0.03,
        Module::CoreList => 1.91,
    },
);

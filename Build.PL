use Module::Build;

Module::Build->new(
		   license       => 'perl',
		   module_name   => 'Test::Distribution',
		   requires      => {
				     'ExtUtils::Manifest' => 1.43,
				     'File::Find::Rule'   => 0.03,
				     'Module::CoreList'   => 1.93,
				     'Test::More'         => 0.45,
				     'Test::Pod'          => 0.95,
						 'Test::Pod::Coverage'=> 0,
				     'Test::Signature'    => 0,
				    },
		   create_readme => 1,
		   sign          => 1,
		   create_makefile_pl => 'passthrough',
       add_to_cleanup      => [ 'Test-Distribution-*' ],
		  )->create_build_script;

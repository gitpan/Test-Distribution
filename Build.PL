use Module::Build;
# See perldoc Module::Build for details of how this works

Module::Build->new(
		   license     => 'perl',
		   module_name => 'Test::Distribution',
		   requires    => {
				   'Test::More'       => 0.45,
				   'Test::Pod'        => 0.95,
				   'File::Find::Rule' => 0.03,
				   'Module::CoreList' => 1.93,
				  },
		   create_readme => 1,
		   sign        => 1,
		  )->create_build_script;

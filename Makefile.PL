use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Jifty::DBI::Record::AutoIncremented',
    VERSION_FROM      => 'lib/Jifty/DBI/Record/AutoIncremented.pm', # finds $VERSION
    PREREQ_PM         => {
        Jifty::DBI => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Jifty/DBI/Record/AutoIncremented.pm',
       AUTHOR         => 'Erwan Lemonnier <erwan@cpan.org>') : ()),
);

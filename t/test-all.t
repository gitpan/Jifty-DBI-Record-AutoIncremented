#################################################################
#
#   $Id: test-all.t,v 1.3 2006/07/28 08:50:20 erwan Exp $
#

package main;

use strict;
use warnings;
use Test::More;
use Data::Dumper;
use lib "../lib";
use lib ".";
use lib "lib/";
use lib "t/";

BEGIN {
    eval "use Jifty::DBI";     plan skip_all => "Jifty::DBI is required for testing Jifty::DBI::Record::AutoIncremented" if $@;
    eval "use DBD::SQLite";    plan skip_all => "DBD::SQLite is required for testing Jifty::DBI::Record::AutoIncremented" if $@;
    eval "use File::Temp";     plan skip_all => "File::Temp is required for testing Jifty::DBI::Record::AutoIncremented" if $@;

    plan tests => 15;

    use_ok('Jifty::DBI::Record::AutoIncremented');
};

require TestDB;

my $obj = MyRecord->new();
is($obj->maximum_value_of,undef,"maximum_value_of() = undef");
is($obj->maximum_value_of('id'),undef,"maximum_value_of(id) = undef");

$obj->create(name => 'first hit', year => 2005);
is($obj->maximum_value_of,1,"maximum_value_of() = 1");
is($obj->maximum_value_of('id'),1,"maximum_value_of(id) = 1");
is($obj->maximum_value_of('year'),2005,"maximum_value_of(year) = 2005");

$obj->create(name => 'future hit', year => 2012);
is($obj->maximum_value_of,2,"maximum_value_of() = 2");
is($obj->maximum_value_of('id'),2,"maximum_value_of(id) = 2");
is($obj->maximum_value_of('year'),2012,"maximum_value_of(year) = 2012");

$obj->create(name => 'previous hit', year => 1999);
is($obj->maximum_value_of,3,"maximum_value_of() = 3");
is($obj->maximum_value_of('id'),3,"maximum_value_of(id) = 3");
is($obj->maximum_value_of('year'),2012,"maximum_value_of(year) = 2012");

$obj->load($obj->maximum_value_of);
is($obj->id,3,"obj->id = 3");
is($obj->name,'previous hit',"obj->name = previous hit");
is($obj->year,1999,"obj->year = 1999");


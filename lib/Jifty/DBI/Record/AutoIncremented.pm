#################################################################
#
#   Jifty::DBI::Record::AutoIncremented - Autoincrement the id field of a Jifty::DBI::Record
#
#   $Id: AutoIncremented.pm,v 1.1 2006/07/28 08:22:22 erwan Exp $
#
#   060728 erwan Started
#
#################################################################

package Jifty::DBI::Record::AutoIncremented;

use 5.006;
use strict;
use warnings;
use Carp qw(croak confess);
use base qw(Jifty::DBI::Record);

our $VERSION = '0.01';

#-----------------------------------------------------------------
#
#   maximum_value_of - returns the current maximum value of a column, or undef
#

sub maximum_value_of {
    my $self = shift;
    my $col = shift || 'id';
    my($max) = $self->_handle->fetch_result("SELECT MAX($col) FROM ".$self->_guess_table_name);
    return $max;
}

#-----------------------------------------------------------------
#
#   before_create - increments this record's id
#

sub before_create {
    my($self,$attribs) = @_;
    if (!defined $attribs->{id}) {
	$attribs->{id} = 1 + ($self->maximum_value_of() || 0);
    }
    return 1;
}

1;

__END__

=head1 NAME

Jifty::DBI::Record::AutoIncremented - Autoincrement the id field of a Jifty::DBI::Record

=head1 VERSION

$Id: AutoIncremented.pm,v 1.1 2006/07/28 08:22:22 erwan Exp $

=head1 SYNOPSIS

Assuming you have a table containing objects of the type MyRecord:

    package MyRecord::Schema;
    use Jifty::DBI::Schema;

    column name => type is 'text';
    column year => type is 'integer';

This table has 3 columns: 'name', 'year' and 'id' that was auto-magically added
by Jifty and is the table's primary key. 'id' is an integer, incremented by 1
upon each insertion of a new row in the table, and starting at 1.

Declare your own Record class inheriting from Jifty::DBI::Record::AutoIncremented:

    package MyRecord;
    use base qw(Jifty::DBI::Record::AutoIncremented);

    sub _init { 
        # some stuff...
    }

Now, creating instances of MyRecord will have each object's 'id' field automatically
incremented to the next available id before insertion. 

   my $mr = MyRecord->new();
   $mr->create(name => 'first hit', year => 2005);  # get's id=1

   # print 1
   print "created a row with id: ".$mr->maximum_value_of()."\n";

   $mr->create(name => 'future hit', year => 2012);  # get's id=2
   $mr->load_by_cols(id => $mr->maximum_value_of);   # load this entry

=head1 DESCRIPTION

Jifty::DBI::Record::AutoIncremented is a subclass of Jifty::DBI::Record
that can be used instead of Jifty::DBI::Record and that transparently
increments a record's id field upon each create/insert.

Some databases 

=head1 INTERFACE

Jifty::DBI::Record::AutoIncremented adds 2 methods to Jifty::DBI::Record:

=over

=item $record->B<maximum_value_of>($column)

Return the current maximum value of the given column in the database. If I<$column> is omitted,
'id' is assumed as the default column. If the table has no entries, undef is returned.

This is particularly usefull after calling I<create> to learn the id of the inserted row.

=item $record->b<before_create>

A callback method called by Jifty::DBI::Record->create. Sets the new record'd id
field to I<maximum_value_of('id')>. If you define your own before_create callback 
in a subclass of Jifty::DBI::Record::AutoIncremented, don't forget to call
this B<before_create> from it.

=back

=head1 BUGS AND LIMITATIONS

No bugs found so far.
Jifty::DBI::Record::AutoIncremented queries the database for the
current maximum value of the id column upon each insert, which
is not so optimal...

=head1 SEE ALSO

See Jifty::DBI::Record.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Erwan Lemonnier C<< <erwan@cpan.org> >>

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

Blablabla not my fault blablabla your responsibility.

=cut




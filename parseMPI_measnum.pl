#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long qw(GetOptions);
use Pod::Usage;
use LWP::Simple;

require MODULES::Database;

my ($file, $debug, $help, $man);
&usage() unless @ARGV > 0;

GetOptions (
'file=s' => \$file,
'd|debug' => \$debug,
'h|help' => \$help,
'm|man' => \$man
);

pod2usage( -verbose => 1 ) if $help;
pod2usage( -verbose => 2 ) if $man;

&usage() unless defined $file;

open (DATEI, $file) or die "Cannot open $file\n";
my @fileContent = <DATEI>;
shift(@fileContent);

foreach my $line (@fileContent){
    my @line_array = split(/\",/ , $line);
    my $line2 = $line_array[0];
    @line_array = split(/,\"/ , $line2);
    my $phenotype  = defined($line_array[1]) ? $line_array[1] : '' ;
    my $line3 = $line_array[0];
    @line_array = split(/,/ , $line3);
    my $measnum    = defined($line_array[0]) ? $line_array[0] : '' ;

    MODULES::Database::insert_mpi_measnum_db($measnum,$phenotype);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: perl parseMPI_meansnum.pl --file <path_to_measnum_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
 parseMPI_measnum.pl - populates the mpi_measnum table in the database with information regarding the phenotypes for the 49 nuclear receptors
 
 =head1 SYNOPSYS
 
 parseMPI_measnum.pl [OPTIONS]
 
 Options:
 -debug debug message
 -help brief help message
 -man full documentation
 
 =head1 OPTIONS
 
 =over 8
 
 =item B<-h|--help>
 
 Prints a brief help message and exits
 
 =item B<-m|--man>
 
 Prints the manual page and exits
 
 =item B<-d|--debug>
 
 Prints the debug message and exits
 
 =item B<--file>
 
 Absolute path to file containing phenotype information for the nuclear receptors
 
 =back
 
 =head1 DESCRIPTION
 
 B<parseMPI_measnum.pl> - populates the mpi_measnum table in the database with information regarding the phenotypes for the 49 nuclear receptors
 
 =head1 EXAMPLE
 
 Usage: perl parseMPI_measnum.pl --file <path_to_measnum_file> [--d|debug]
 
 =cut


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
    my @line_array = split(/,/ , $line);
    my $phenotype  = defined($line_array[0]) ? $line_array[0] : '' ;
    my $strain     = defined($line_array[2]) ? $line_array[2] : '' ;
    my $strain_id  = defined($line_array[3]) ? $line_array[3] : '' ;
    my $sex        = defined($line_array[4]) ? $line_array[4] : '' ;
    my $mean       = defined($line_array[5]) ? $line_array[5] : '' ;
    my $nmice      = defined($line_array[6]) ? $line_array[6] : '' ;
    my $minval     = defined($line_array[10]) ? $line_array[10] : '' ;
    my $maxval     = defined($line_array[11]) ? $line_array[11] : '' ;
    my $zscore     = defined($line_array[14]) ? $line_array[14] : '' ;

    MODULES::Database::insert_mpi_strainmeans_db($phenotype, $strain, $strain_id, $sex, $mean, $nmice, $minval, $maxval, $zscore);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: perl parseMPI_strainmean.pl --file <path_to_strainmean_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
 parseMPI_strainmeans.pl - populates the mpi_strainmeans table in the database with strain information regarding the 49 nuclear receptors
 
 =head1 SYNOPSYS
 
 parseMPI_strainmeans.pl [OPTIONS]
 
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
 
 Absolute path to file containing information regarding the strain means for the nuclear receptors
 
 =back
 
 =head1 DESCRIPTION
 
 B<parseMPI_strainmeans.pl> populates the mpi_strainmeans table in the database with strain information regarding the 49 nuclear receptors
 
 =head1 EXAMPLE
 
 Usage: perl parseMPI_strainmeans.pl --file <path_to_strainmeans_file> [--d|debug]
 
 =cut


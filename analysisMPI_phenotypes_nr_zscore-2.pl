#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;
use Getopt::Long qw(GetOptions);
use Pod::Usage;

require MODULES::PlotsExtract;
require MODULES::PlotsGenerate;
require MODULES::Functions;

my ($outputFile, $debug, $help, $man);

GetOptions (
'outputFile=s' => \$outputFile,
'd|debug' => \$debug,
'h|help' => \$help,
'm|man' => \$man
);

pod2usage( -verbose => 1 ) if $help;
pod2usage( -verbose => 2 ) if $man;

usage() unless defined $outputFile;

sub usage{
    print "Incorrect parameters! \n";
    print "Usage: perl analysisMPI_phenotypes_nr_zscore-2.pl --outputFile <path_to_plot_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

#extract plot data
my ($phenotypes, $nr, $count) = MODULES::PlotsExtract::get_analysisMPI_phenotypes_nr_zscore2_neg();

#transform
my $csv = "./datei.csv";
MODULES::Functions::toMatrix($phenotypes, $nr, $count, $csv);

#generate plots
MODULES::PlotsGenerate::plotHeatmap($csv, $outputFile);


__END__

=head1 NAME

 analysisMPI_phenotypes_nr_zscore-2.pl - creates MPI-Strain-Phenotypes having zscore < -2 distribution plot, for the phenotypes found in the MPI database.
 Please include absolute path in the arguements.
 
 =head1 SYNOPSYS
 
 analysisMPI_phenotypes_strain_zscore-2.pl [OPTIONS]
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
 
 =item B<--outputFile>
 
 Filename to write plot to (PDF format).
 
 =back
 
 =head1 DESCRIPTION
 
 B<analysisMPI_phenotypes_strain_zscore-2.pl> creates MPI-Strain-Phenotypes having zscore < -2 distribution plot, for the phenotypes found in the MPI database.
 
 =head1 EXAMPLE
 
 Usage: perl analysisMPI_phenotypes_strain_zscore-2.pl --outputFile <path_to_plot_file>

=cut
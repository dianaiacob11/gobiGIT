#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;
use Getopt::Long qw(GetOptions);
use Pod::Usage;

require MODULES::PlotsExtract;
require MODULES::PlotsGenerate;

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
    print "Usage: perl analysisMGI_phenotype_nr.pl --outputFile <path_to_plot_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

#extract plot data
my $csv = MODULES::PlotsExtract::get_analysisMGI_phenotypes_nr();

#generate plots
MODULES::PlotsGenerate::plotHeatmap($csv, $outputFile);


__END__

=head1 NAME

 analysisMGI_phenotypes_nr.pl - creates MGI-NR-Phenotypes distribution plot over 49 nuclear receptors, for the phenotypes found in the MGI database.
 Please include absolute path in the arguements.
 
 =head1 SYNOPSYS
 
 analysisMGI_phenotypes_nr.pl [OPTIONS]
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
 
 B<analysisMGI_phenotypes_nr.pl> generates MGI-NR-Phenotypes distribution plot.
 
 =head1 EXAMPLE
 
 Usage: perl analysisMGI_phenotypes_nr.pl --outputFile <path_to_plot_file>

=cut
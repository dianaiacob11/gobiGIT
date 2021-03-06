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
    print "Usage: perl analysisMGI_phenotype_distribution_zscore-2.pl --outputFile <path_to_plot_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

#extract plot data
my ($phenotypes, $percentage, $count, $total_phenotypes) = MODULES::PlotsExtract::get_analysisMPI_phenotypes_distribution_zscore2_neg();

#transform plot data
my $x_axis                  = $phenotypes;
my $y_axis                  = $percentage;
my $xlab                    = "Phenotypes";
my $ylab                    = "Phenotype frequency for nuclear receptors, having Z-score < -2";
my $legend_count_phenotypes = "MPI Phenotypes: ".$total_phenotypes;
my $legend_count_nr         = "Nuclear receptors: 49";
my $label                   = $count;

#generate plots
MODULES::PlotsGenerate::plotVerticalString($x_axis, $y_axis, $outputFile, $xlab, $ylab, $legend_count_phenotypes, $legend_count_nr, $label);


__END__

=head1 NAME

 analysisMPI_phenotypes_distribution_zscore-2.pl - creates MPI-Phenotypes distribution plot for the phenotypes found in the MGI database, associated with strings having z-score < -2.
 Please include absolute path in the arguements.
 
 =head1 SYNOPSYS
 
 analysisMPI_phenotypes_distribution_zscore-2.pl [OPTIONS]
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
 
 B<analysisMPI_phenotypes_distribution_zscore-2.pl> generates MPI-Phenotypes distribution plot, for z-score < -2.
 
 =head1 EXAMPLE
 
 Usage: perl analysisMPI_phenotypes_distribution_zscore-2.pl --outputFile <path_to_plot_file>

=cut
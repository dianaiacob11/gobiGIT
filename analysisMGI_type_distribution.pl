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
    print "Usage: perl analysisMGI_type_distribution.pl --outputFile <path_to_plot_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

#extract plot data
my ($types, $percentage, $count, $total_types) = MODULES::PlotsExtract::get_analysisMGI_type_distribution();

#transform plot data
my $x_axis                  = $types;
my $y_axis                  = $percentage;
my $xlab                    = "Allele types";
my $ylab                    = "Allele type frequency for nuclear receptors";
my $legend_count_types      = "Allele_types: ".$total_types;
my $legend_count_nr         = "Nuclear receptors: 49";
my $label                   = $count;

print $x_axis."\n".$y_axis."\n".$xlab."\n".$ylab."\n".$legend_count_types."\n".$legend_count_nr."\n".$label."\n";

#generate plots
MODULES::PlotsGenerate::plotVerticalString($x_axis, $y_axis, $outputFile, $xlab, $ylab, $legend_count_phenotypes, $legend_count_nr, $label);


__END__

=head1 NAME

 analysisMGI_type_distribution.pl - creates MGI-Allele Type distribution plot for the allele types found in the MGI database.
 Please include absolute path in the arguements.
 
 =head1 SYNOPSYS
 
 analysisMGI_type_distribution.pl [OPTIONS]
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
 
 B<analysisMGI_type_distribution.pl> generates MGI-Allele Type distribution plot.
 
 =head1 EXAMPLE
 
 Usage: perl analysisMGI_type_distribution.pl --outputFile <path_to_plot_file>

=cut
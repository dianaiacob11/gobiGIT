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
my ($phenotypes, $phenotypes_per_nr, $plotlabel, $total_phenotypes) = MODULES::PlotsExtract::get_analysisMGI_phenotypes_nr();

#transform plot data
my $rowNames                = $phenotypes;
my $count                   = $phenotypes_per_nr;
my $xlab                    = "Phenotypes";
my $ylab                    = "Phenotype frequency for nuclear receptors";
my $legend_count_phenotypes = "MGI Phenotypes: ".$total_phenotypes;
my $legend_count_nr         = "Nuclear receptors: 49";
my $label                   = $plotlabel;

print $rowNames."\n".$count."\n".$xlab."\n".$ylab."\n".$legend_count_phenotypes."\n".$legend_count_nr."\n".$label."\n";

#generate plots
#MODULES::PlotsGenerate::plotMPI_phenotypes_nr($rowNames, $count, $outputFile, $xlab, $ylab, $legend_count_phenotypes, $legend_count_nr, $label);
MODULES::PlotsGenerate::plotHeatmap($rowNames, $count, $outputFile, $xlab, $ylab, $legend_count_phenotypes, $legend_count_nr, $label);


__END__

=head1 NAME

 analysisLC3_distribution.pl - Create LocTree3 distribution plot for 6 subcellular localization classes.
 It can be used to compare a dataset against core bacteria reference dataset or two input datasets against each other.
 Please include absolute path in the arguements.
 
 =head1 SYNOPSYS
 
 analysisLC3_distribution.pl [OPTIONS]
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
 
 =item B<--jobID>
 
 Unique identifier of the current job (corresponding to a value in the jobID column in the MD5Seq database table)
 
 =item B<--outputFile>
 
 Filename to write plot to (PDF format).
 
 =item B<--dataset_vs_dataset>
 
 Compare two datasets against each other, instead of dataset against reference.
 If two datasets are compared, the dataset column in the MD5Seq table needs to
 be set to 1 or 2 for each sequence.
 Default: dataset against reference.
 
 =item B<--dataset_name1>
 
 Optional: name to display in plot for first dataset.
 Default: 'Dataset'
 
 =item B<--dataset_name2>
 
 Optional: name to display in plot for second dataset.
 Default: 'Reference'
 
 =back
 
 =head1 DESCRIPTION
 
 B<analysisLC3_distribution.pl> generates LocTree3 distribution plot.
 
 =head1 EXAMPLE
 
 Usage: perl ./analysisLC3_distribution.pl --jobID <jobID> --outputFile <path_to_plot_file> [--d|debug] [--dataset_vs_dataset] [--dataset_name1 <dataset_name_1>] [--dataset_name2 <dataset_name_2>]

=cut
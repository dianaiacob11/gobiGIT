#!/usr/bin/perl -w
use strict;
use warnings;
use Carp qw(cluck :DEFAULT);
use Getopt::Long qw(GetOptions);
use Pod::Usage;
use File::Path qw(make_path);
use File::Path;
use Config::IniFiles;
use lib '.';

my ($outputDir, $help, $man, $debug);

GetOptions (
  'outputDir=s' => \$outputDir,
  'd|debug' => \$debug,
  'h|help' => \$help,
  'm|man' => \$man
);

pod2usage( -verbose => 1 ) if $help;
pod2usage( -verbose => 2 ) if $man;

usage() unless defined $outputDir;

make_path ($outputDir);

my $mgi_phenotypes_distribution_file = $outputDir."/mgi_phenotypes_distribution.pdf";
system (" perl ./analysisMGI_phenotypes_distribution.pl --outputFile $mgi_phenotypes_distribution_file");

my $mgi_types_distribution_file = $outputDir."/mgi_types_distribution.pdf";
system (" perl ./analysisMGI_types_distribution.pl --outputFile $mgi_types_distribution_file");

my $mpi_phenotypes_distribution_zscore2_file = $outputDir."/mpi_phenotypes_distribution_zscore2.pdf";
system (" perl ./analysisMPI_phenotypes_distribution_zscore2.pl --outputFile $mpi_phenotypes_distribution_zscore2_file");
 
my $mpi_phenotypes_distribution_zscore2_neg_file = $outputDir."/mpi_phenotypes_distribution_zscore2_neg.pdf";
 system (" perl ./analysisMPI_phenotypes_distribution_zscore-2.pl --outputFile $mpi_phenotypes_distribution_zscore2_neg_file");

my $mgi_phenotypes_nr_file = $outputDir."/mgi_phenotypes_nr.pdf";
system (" perl ./analysisMGI_phenotypes_nr.pl --outputFile $mgi_phenotypes_nr_file");

my $mgi_types_nr_file = $outputDir."/mgi_types_nr.pdf";
system (" perl ./analysisMGI_types_nr.pl --outputFile $mgi_types_nr_file");
 
my $mpi_phenotypes_strain_zscore2_file = $outputDir."/mpi_phenotypes_strain_zscore2.pdf";
system (" perl ./analysisMPI_phenotypes_strain_zscore2.pl --outputFile $mpi_phenotypes_strain_zscore2_file");

my $mpi_phenotypes_strain_zscore2_neg_file = $outputDir."/mpi_phenotypes_strain_zscore2_neg.pdf";
system (" perl ./analysisMPI_phenotypes_strain_zscore-2.pl --outputFile $mpi_phenotypes_strain_zscore2_neg_file");

my $mpi_snp_distribution_file = $outputDir."/mpi_snp_distribution.pdf";
system (" perl ./analysisMPI_snp_distribution.pl --outputFile $mpi_snp_distribution_file");

my $mpi_snp_function_distribution_file = $outputDir."/mpi_snp_function_distribution.pdf";
system (" perl ./analysisMPI_snp_function_distribution.pl --outputFile $mpi_snp_function_distribution_file");


sub usage{
    print "Incorrect command line parameters! \n";
    print "Usage: perl plotPipeline.pl --outputDir <path_to_output_folder> [--d|debug] \n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
plotPipeline.pl - Pipeline for plots
Please include absolute path in the arguements.
 
=head1 SYNOPSYS
 
 plotPipeline.pl [OPTIONS]
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
 
=item B<--outputDir>
 
Path to the directory in which the output results shall be saved (temporarily)
 
=back

=head1 DESCRIPTION
 
B<plotPipeline.pl> is the main script that calls all the other scripts for the plots.

=head1 EXAMPLE

Usage: perl plotPipeline.pl --outputDir <path_to_output_folder> [--d|debug]

=cut
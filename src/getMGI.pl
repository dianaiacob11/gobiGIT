#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long qw(GetOptions);
use Pod::Usage;
use LWP::Simple;

require MODULES::Functions;

my ($file, $dir, $debug, $help, $man);
&usage() unless @ARGV > 1;

GetOptions (
'file=s' => \$file,
'dir=s' => \$dir,
'd|debug' => \$debug,
'h|help' => \$help,
'm|man' => \$man
);

pod2usage( -verbose => 1 ) if $help;
pod2usage( -verbose => 2 ) if $man;

&usage() unless defined $file and defined $dir;

open (DATEI, $file) or die "Cannot open $file\n";
my @fileContent = <DATEI>;

foreach my $id (@fileContent){
    chomp($id);
    MODULES::Functions::saveAnnotationToFile($id, $dir);
}

sub usage{
    print "Incorrect parameters! \n";
    print "Usage: perl getMGI.pl --file <path_to_gene_id_file> --dir <path_to_mgi_folder> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
getMGI.pl - downloads and saves the annotations from the MGI database for a list of gene ids
Please include absolute path in the arguements.
 
=head1 SYNOPSYS
 
getMGI.pl [OPTIONS]
 
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
 
Absolute path to file of gene ids
 
=item B<--dir>
 
Absolute path to directory in which the annotation files for the gene ids will be saved
 
=back
 
=head1 DESCRIPTION
 
B<getMGI.pl> downloads and saves the annotations from the MGI database for a list of gene ids
 
=head1 EXAMPLE
 
Usage: perl getMGI.pl --file <path_to_gene_id_file> --dir <path_to_mgi_folder> [--d|debug]
 
=cut
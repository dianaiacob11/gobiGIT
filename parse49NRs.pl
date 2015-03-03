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

open (DATEI, $file) or die "Cannot open $file!\n";
my @fileContent = <DATEI>;
shift(@fileContent);

foreach my $line (@fileContent){
    my @line_array      = split(/,/,$line);
    my $gene_id         = defined($line_array[0]) ? $line_array[0] : "" ;
    my $transcript_id   = defined($line_array[1]) ? $line_array[1] : "" ;
    my $protein_id      = defined($line_array[2]) ? $line_array[2] : "" ;
    my $gene_name       = defined($line_array[3]) ? $line_array[3] : "" ;
    my $sequence        = defined($line_array[4]) ? $line_array[4] : "" ;
    my $mouse_id        = defined($line_array[5]) ? $line_array[5] : "" ;
    
    $gene_id        =~ s/\"//g;
    $transcript_id  =~ s/\"//g;
    $protein_id     =~ s/\"//g;
    $gene_name      =~ s/\"//g;
    $sequence       =~ s/\"//g;
    
    MODULE::Database::insert_nr_mapping_db($gene_id, $transcript_id, $protein_id, $gene_name, $sequence, $mouse_id);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: perl parse49NRs.pl -file <path_to_nr_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
 parse49NRs.pl - populates the nr_mapping table in the database with information regarding the 49 nuclear receptors
 
 =head1 SYNOPSYS
 
 parse49NRs.pl [OPTIONS]
 
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
 
 Absolute path to file of nuclear receptors
 
 =back
 
 =head1 DESCRIPTION
 
 B<parse49NRs.pl> populates the nr_mapping table in the database with information regarding the 49 nuclear receptors
 
 =head1 EXAMPLE
 
 Usage: perl parse49NRs.pl --file <path_to_nr_file> [--d|debug]
 
 =cut

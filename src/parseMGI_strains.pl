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
    my @line_array = split(/\t/,$line);
    my $mgi_id     = defined($line_array[0]) ? $line_array[0] : "" ;
    my $strain_name= defined($line_array[1]) ? $line_array[1] : "" ;
    my $strain_type= defined($line_array[2]) ? $line_array[2] : "" ;
    
    $mgi_id        =~ s/\"//g;
    $strain_name   =~ s/\"//g;
    $strain_type   =~ s/\"//g;
    #print "MGI: ".$mgi_id." - Strain Name: ".$strain_name." - Type: ".$strain_type."\n";
    MODULES::Database::insert_mgi_strains_db($mgi_id,$strain_name,$strain_type);
}

sub usage{
    print "Incorrect parameters! \n";
    print "Usage: perl parseMGI_strains.pl --file <path_to_strains_file>[--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
 parseMGI_strains.pl - populates the mgi_strains table in the database with information regarding the strains for the 49 nuclear receptors
 
 =head1 SYNOPSYS
 
 parseMGI_strains.pl [OPTIONS]
 
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
 
 Absolute path to file containing strains information for the nuclear receptors
 
 =back
 
 =head1 DESCRIPTION
 
 B<parseMGI_strains.pl> - populates the mgi_strains table in the database with information regarding the strains for the 49 nuclear receptors
 
 =head1 EXAMPLE
 
 Usage: perl parseMGI_strains.pl --file <path_to_strains_file> [--d|debug]
 
 =cut



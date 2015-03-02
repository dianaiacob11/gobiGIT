#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;

my ($file, $debug);
if (@ARGV < 1){ die "Usage: $0 --file <path_to_strainmean_file> [--d|debug]\n";}

my $result = GetOptions (
'file=s' => \$file,
'd|debug' => \$debug
);

&usage() unless defined($file);

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

    print $phenotype.",  ".$strain.",  ".$strain_id.",  ".$sex.",  ".$mean.",  ".$nmice.",  ". $minval.",  ".$maxval.",  ".$zscore."\n";
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMPI_strainmean.pl --file <path_to_strainmean_file> [--d|debug]\n";
}


__END__
#TODO: write pom

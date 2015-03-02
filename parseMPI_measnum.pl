#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;

my ($file, $debug);
if (@ARGV < 1){ die "Usage: $0 --file <path_to_measnum_file> [--d|debug]\n";}

my $result = GetOptions (
'file=s' => \$file,
'd|debug' => \$debug
);

&usage() unless defined($file);

open (DATEI, $file) or die "Cannot open $file\n";
my @fileContent = <DATEI>;
shift(@fileContent);

foreach my $line (@fileContent){
    my @line_array = split(/\",/ , $line);
    my $line2 = $line_array[0];
    @line_array = split(/,\"/ , $line2);
    my $phenotype  = defined($line_array[1]) ? $line_array[1] : '' ;
    my $line3 = $line_array[0];
    @line_array = split(/,/ , $line3);
    my $measnum    = defined($line_array[0]) ? $line_array[0] : '' ;

    
    print $phenotype.",  ".$measnum."\n";
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMPI_meansnum.pl --file <path_to_measnum_file> [--d|debug]\n";
}


__END__
#TODO: write pom

#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;

my ($dir, $debug);
if (@ARGV < 1){ die "Usage: $0 --dir <path_to_MGI_file_directory> [--d|debug]\n";}

my $result = GetOptions (
'dir=s' => \$dir,
'd|debug' => \$debug
);

&usage() unless defined($dir);

opendir(DIR, $dir) or die "Cannot open $dir!";
my @dir = readdir DIR;

foreach my $file (@dir) {
    my $filePath = $dir."/".$file;
    open (DATEI, $filePath) or die "\nCannot open $filePath!\n";
    my @fileContent=<DATEI>;
    shift(@fileContent);
    
    foreach my $line (@fileContent){
        my @line_array = split(/\t/,$line);
        my $allele_id         = defined($line_array[0]) ? $line_array[0] : "" ;
        my $allele_name       = defined($line_array[2]) ? $line_array[2] : "" ;
        my $chr               = defined($line_array[3]) ? $line_array[3] : "" ;
        my $allele_type       = defined($line_array[5]) ? $line_array[5] : "" ;
        my $allele_attributes = defined($line_array[6]) ? $line_array[6] : "" ;
        
        print $allele_id."\n";
    }

}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMGI --dir <path_to_MGI_file_directory> [--d|debug]\n";
}


__END__
#TODO: write pom

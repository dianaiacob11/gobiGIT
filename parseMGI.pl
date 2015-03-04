#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long qw(GetOptions);
use Pod::Usage;
use LWP::Simple;

require MODULES::Database;
require MODULES::Functions;

my ($dir, $debug, $help, $man);
&usage() unless @ARGV > 0;

GetOptions (
'dir=s' => \$dir,
'd|debug' => \$debug,
'h|help' => \$help,
'm|man' => \$man
);

pod2usage( -verbose => 1 ) if $help;
pod2usage( -verbose => 2 ) if $man;

&usage() unless defined $dir;

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
        $allele_id =~s/\s+//g;
        my $len = length($allele_id);
        my $allele_name       = defined($line_array[2]) ? $line_array[2] : "" ;
        my $chr               = defined($line_array[3]) ? $line_array[3] : "" ;
        my $allele_type       = defined($line_array[5]) ? $line_array[5] : "" ;
        my $allele_attributes = defined($line_array[6]) ? $line_array[6] : "" ;
        my $transmission      = defined($line_array[7]) ? $line_array[7] : "" ;
        my $phenotype         = defined($line_array[8]) ? $line_array[8] : "" ;
        
        if ($len > 0){
            MODULES::Database::insert_mgi_db($allele_id, $allele_name, $chr, $allele_type, $allele_attributes, $transmission);
            &parsePhenotype($phenotype, $allele_id);
        }
    }
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: perl parseMGI.pl --dir <path_to_mgi_file_directory> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

sub parsePhenotype{
    my $pheno_string = $_[0]; # e.g. growth/size/body | homeostasis | limbs/digits/tail
    my $allele_id    = $_[1]; # e.g. MGI:3604810
    my @pheno_array  = split(/\s+|\s+/, $pheno_string);
    foreach my $phenotype (@pheno_array)
    {
        if($phenotype ne "|")
        {
            my $phenotype_id = MODULES::Functions::generateMD5($phenotype);
            MODULES::Database::insert_mgi_phenotypes_db($phenotype_id, $phenotype, $allele_id);
        }
    }
}

__END__

=head1 NAME
 
 parseMGI.pl - populates the mgi and mgi_phenotypes tables in the database with information regarding the mgi annotations for the 49 nuclear receptors
 
 =head1 SYNOPSYS
 
 parseMGI.pl [OPTIONS]
 
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
 
 =item B<--dir>
 
 Absolute path to directory contatining text files of the annotations of nuclear receptors
 
 =back
 
 =head1 DESCRIPTION
 
 B<parseMGI.pl> populates the mgi and mgi_phenotypes tables in the database with information regarding the mgi annotations for the 49 nuclear receptors
 
 =head1 EXAMPLE
 
 Usage: perl parseMGI.pl --dir <path_to_mgi_file_directory> [--d|debug]
 
 =cut


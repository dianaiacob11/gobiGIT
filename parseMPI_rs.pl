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

open (DATEI, $file) or die "Cannot open $file\n";
my @fileContent = <DATEI>;

#get strain names;
my $header = $fileContent[10];
my @header_array = split(/\s+/ , $header);
pop @header_array;
my @strains = '';
for (my $i=11; $i<scalar(@header_array); $i++){
    push @strains, $header_array[$i];
    MODULES::Database::insert_mpi_rs_strains_db($header_array[$i]);
}

foreach my $line (@fileContent){
    my @line_array = split(/\s+/ , $line);
    my $gene_name          = '';
    my $rs                 = '';
    my $substitution       = '';
    my @substitution_array = '';
    my $expected           = '';
    my $observed           = '';
    my $strain             = '';
    if(defined($line_array[2]) && $line_array[2] ne "="){
        $gene_name       = $line_array[2];
        $gene_name       =~s/\s+//g;
        $rs              = defined($line_array[9]) ? $line_array[9] : '' ;
        $substitution    = defined($line_array[10]) ? $line_array[10] : '' ;
        @substitution_array = split(/\//, $substitution);
        $expected = defined($substitution_array[0]) ? $substitution_array[0] : '' ;
        for(my $j=11; $j<scalar(@line_array); $j++){
            $strain   = $strains[$j-10];
            if(defined($line_array[$j]) && $line_array[$j] ne $expected && length($gene_name)>0 && defined($strain)){
                $observed = $line_array[$j];
                #print $gene_name.", ".$rs.", ".$substitution.", ".$expected.", ".$observed.", ".$strain."\n";
                MODULES::Database::insert_mpi_rs_db($gene_name, $rs, $expected, $observed, $strain, $substitution);
            }
        }
    }
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: perl parseMPI_rs.pl --file <path_to_mpi_file> [--d|debug]\n";
    print "       $0 --help \n";
    print "       $0 --man \n";
    exit;
}

__END__

=head1 NAME
 
 parseMPI_rs.pl - populates the mpi_rs and mpi_rs_strains tables in the database with information regarding the strains and rs numbers for the nuclear receptors
 
 =head1 SYNOPSYS
 
 parseMPI_rs.pl [OPTIONS]
 
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
 
 Absolute path to rs file for nuclear receptors
 
 =back
 
 =head1 DESCRIPTION
 
 B<parseMPI_rs.pl> populates the mpi_rs and mpi_rs_strains tables in the database with information regarding the strains and rs numbers for the nuclear receptors
 
 =head1 EXAMPLE
 
 Usage: perl parseMPI_rs.pl --file <path_to_rs_file> [--d|debug]
 
 =cut

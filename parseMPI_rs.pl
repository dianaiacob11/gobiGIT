#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;
use DBI;

my $database = "gobi";
my $db = &connectToDB($database);


my ($file, $debug);
if (@ARGV < 1){ die "Usage: $0 --file <path_to_mpi_file> [--d|debug]\n";}

my $result = GetOptions (
'file=s' => \$file,
'd|debug' => \$debug
);

&usage() unless defined($file);

open (DATEI, $file) or die "Cannot open $file\n";
my @fileContent = <DATEI>;

#get strain names;
my $header = $fileContent[10];
my @header_array = split(/\s+/ , $header);
pop @header_array;
my @strains = '';
for (my $i=11; $i<scalar(@header_array); $i++){
    push @strains, $header_array[$i];
    &insertToRSStrainDB($header_array[$i]);
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
                print $gene_name.", ".$rs.", ".$substitution.", ".$expected.", ".$observed.", ".$strain."\n";
                &insertToDB($gene_name, $rs, $expected, $observed, $strain, $substitution);
            }
        }
    }
}
sub connectToDB{
    
    my $database    = $_[0];
    my $host        = "164.177.170.83";
    my $user        = "root";
    my $pw          = "";
    
    my $dsn         = "dbi:mysql:$database:$host";
    my $dbh = DBI->connect($dsn, $user, $pw) or die "Error connecting to database.";
    
    return $dbh;
}

sub insertToRSStrainDB{
    my $dbTable = "mpi_rs_strains";
    my $query = "INSERT IGNORE INTO ".$dbTable."(strain_name) VALUES (?,)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0]);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMPI_rs.pl --file <path_to_mpi_file> [--d|debug]\n";
}

sub insertToDB{
    
    my $dbTable = "mpi_rs";
    my $query = "INSERT IGNORE INTO ".$dbTable."(gene_name, rs_id, expected, observed, strain_name, substitution) VALUES (?,?,?,?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);
}

__END__
#TODO: write pom

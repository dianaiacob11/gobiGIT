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

    insertToDB($phenotype, $strain, $strain_id, $sex, $mean, $nmice, $minval, $maxval, $zscore);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMPI_strainmean.pl --file <path_to_strainmean_file> [--d|debug]\n";
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

sub insertToDB{
    
    my $dbTable = "mpi_strainmeans";
    my $query = "INSERT IGNORE INTO ".$dbTable."(measnum, strain, strain_id, sex, mean, number_mice, minval, maxval, score) VALUES (?,?,?,?,?,?,?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5], $_[6], $_[7], $_[8]);    
}


__END__
#TODO: write pom

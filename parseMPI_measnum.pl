#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;

my $database = "gobi";
my $db = &connectToDB($database);

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

    
    #print $phenotype.",  ".$measnum."\n";
    insertToDB($measnum,$phenotype);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./parseMPI_meansnum.pl --file <path_to_measnum_file> [--d|debug]\n";
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
    
    my $dbTable = "mpi_measnum";
    my $query = "INSERT IGNORE INTO ".$dbTable."(measnum, phenotype) VALUES (?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1]);    
}


__END__
#TODO: write pom

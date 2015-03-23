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
if (@ARGV < 1){ die "Usage: $0 --file <path_to_NR_file> [--d|debug]\n";}

my $result = GetOptions (
'file=s' => \$file,
'd|debug' => \$debug
);

&usage() unless defined($file);

open (DATEI, $file) or die "Cannot open $file!\n";
my @fileContent = <DATEI>;
shift(@fileContent);

foreach my $line (@fileContent){
    my @line_array = split(/\t/,$line);
    my $chromosome_tmp  = defined($line_array[1]) ? $line_array[1] : "" ;
    my $start_location  = defined($line_array[2]) ? $line_array[2] : "" ;
    my $end_location    = defined($line_array[3]) ? $line_array[3] : "" ;
    my $rs_id           = defined($line_array[4]) ? $line_array[4] : "" ;
    my $strand          = defined($line_array[6]) ? $line_array[6] : "" ;
    my $refNCBI         = defined($line_array[7]) ? $line_array[7] : "" ;
    my $refUCSC         = defined($line_array[8]) ? $line_array[8] : "" ;
    my $observed        = defined($line_array[9]) ? $line_array[9] : "" ;
    my $function        = defined($line_array[15]) ? $line_array[15] : "" ;
    my $alleles         = defined($line_array[22]) ? $line_array[22] : "" ;
    
    $chromosome_tmp  =~ s/\"//g;
    $start_location  =~ s/\"//g;
    $end_location    =~ s/\"//g;
    $rs_id           =~ s/\"//g;
    $strand          =~ s/\"//g;
    $refNCBI         =~ s/\"//g;
    $refUCSC         =~ s/\"//g;
    $observed        =~ s/\"//g;
    $function        =~ s/\"//g;
    $alleles         =~ s/\"//g;
    my $chromosome = substr($chromosome_tmp, 3);

    #print $chromosome." ".$start_location." ".$end_location." ".$rs_id." ".$strand." ".$refNCBI." ".$refUCSC." ".$observed." ".$function." ".$alleles."\n";
    insertToDB($chromosome,$start_location,$end_location,$rs_id,$strand,$refNCBI,$refUCSC,$observed,$function,$alleles);
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./getMGI --gene_id_file <path_to_gene_id_file> --dir <path_to_mgi_folder> [--d|debug]\n";
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
    
    my $dbTable = "ucsc_variants";
    my $query = "INSERT IGNORE INTO ".$dbTable."(chromosome, start_location, end_location, rs_id, strand, refNCBI, refUCSC, observed, function, alleles ) VALUES (?,?,?,?,?,?,?,?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5], $_[6], $_[7], $_[8], $_[9]);    
}

__END__
#TODO: write pom

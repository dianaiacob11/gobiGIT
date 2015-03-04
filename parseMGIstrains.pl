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
    my $mgi_id          = defined($line_array[0]) ? $line_array[0] : "" ;
    my $strain_name     = defined($line_array[1]) ? $line_array[1] : "" ;
    my $strain_type     = defined($line_array[2]) ? $line_array[2] : "" ;
    
    $mgi_id        =~ s/\"//g;
    $strain_name  =~ s/\"//g;
    $strain_type     =~ s/\"//g;
    #print "MGI: ".$mgi_id." - Strain Name: ".$strain_name." - Type: ".$strain_type."\n";
    insertToDB($mgi_id,$strain_name,$strain_type);
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
    
    my $dbTable = "mgi_strains";
    my $query = "INSERT IGNORE INTO ".$dbTable."(mgi_id, strain_name, strain_type) VALUES (?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2]);    
}

__END__
#TODO: write pom

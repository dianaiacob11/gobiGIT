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
    my @line_array = split(/,/,$line);
    my $gene_id         = defined($line_array[0]) ? $line_array[0] : "" ;
    my $transcript_id   = defined($line_array[1]) ? $line_array[1] : "" ;
    my $protein_id      = defined($line_array[2]) ? $line_array[2] : "" ;
    my $gene_name       = defined($line_array[3]) ? $line_array[3] : "" ;
    my $sequence        = defined($line_array[4]) ? $line_array[4] : "" ;
    my $mouse_id        = defined($line_array[5]) ? $line_array[5] : "" ;
    
    $gene_id        =~ s/\"//g;
    $transcript_id  =~ s/\"//g;
    $protein_id     =~ s/\"//g;
    $gene_name       =~ s/\"//g;
    $sequence       =~ s/\"//g;
    
    insertToDB($gene_id,$transcript_id,$protein_id,$gene_name,$sequence,$mouse_id);
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
    
    my $dbTable = "nr_mapping";
    my $query = "INSERT IGNORE INTO ".$dbTable."(gene_id, transcript_id, protein_id, gene_name, sequence, mouse_id ) VALUES (?,?,?,?,?,?)";
    print $query."\n";
    my $sth = $db->prepare($query);
    $sth->execute($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);    
}

__END__
#TODO: write pom

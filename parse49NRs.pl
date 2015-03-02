#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Getopt::Long;
use LWP::Simple;

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
    gene_name       =~ s/\"//g;
    $sequence       =~ s/\"//g;
    
    print $gene_id."\n".$transcript_id."\n".$protein_id."\n".$gene_name."\n".$sequence."\n".$mouse_id."\n\n";
}

sub usage{
    print "Incorrect parameters \n";
    print "Usage: ./getMGI --gene_id_file <path_to_gene_id_file> --dir <path_to_mgi_folder> [--d|debug]\n";
}

sub connectToDB{
    
    my $database    = $_[0];
    my $host        = "192.168.1.47";
    my $user        = "diacob";
    my $pw          = "Z6545NPJn5Z968B";
    
    my $dsn         = "dbi:mysql:$database:$host";
    my $dbh = DBI->connect($dsn, $user, $pw) or die "Error connecting to database.";
    
    return $dbh;
}

my $db = &connectToDB($database);

sub insertToDB{
    
    
    my $query = "INSERT IGNORE INTO ".$dbTable."(  col1, col2, ) VALUES ( '". ."'   ";
    my $sth = $db->prepare($query);
    $sth->execute();
}

__END__
#TODO: write pom

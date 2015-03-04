package MODULES::PlotsExtract;

use strict;
use warnings;
use diagnostics;

use DBI;
use DBD::mysql;

use lib '.';
require MODULES::Database;

my $db = MODULES::Database::connectToDB("gobi");

sub                 get_analysisMGI_phenotypes_nr{
   
    my $dbTable1            = 'mgi_phenotypes';
    my $dbTable2            = 'mgi';
    my $query              = "";

    $query   = " SELECT p.phenotype_name,m.allele_name,COUNT(*) AS count "
             . " FROM ".$dbTable1." p "
             . " JOIN ".$dbTable2." m "
             . " ON p.mgi_allele_id = m.allele_id"
             . " GROUP BY p.phenotype_name ORDER BY count DESC";

    my $sth       = $db->prepare($query);

    $sth->execute() or die $DBI::errstr;

    my @row;
    my $phenotypes = '';
    my $nr = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        $phenotypes  = join(',', $phenotypes, $row[0]);
        chomp($phenotypes);
        
        $nr = join(',', $nr, $row[1]);
        chomp($nr);
        
        $count  = join(',', $count, $row[2]);
        chomp($count);
    }
    
    $phenotypes =~ s/.//;
    $nr         =~ s/.//;
    $count      =~ s/.//;

    return ($phenotypes, $nr, $count);
    
}

=co

sub                 get_analysisMGI_phenotypes_distribution{

    my $dbTable            = 'mgi_phenotypes';
    my $query              = "";
    my $query_total        = "";

    $query   = " SELECT phenotype_name, COUNT(*) AS count "
             . " FROM ".$dbTable
             . " GROUP BY phenotype_name "
             . " ORDER BY count DESC";
    $query_total = " SELECT COUNT(*) FROM ".$dbTable;
    
    my $sth       = $db->prepare($query);
    my $sth_total = $db->prepare($query_total);
    
    $sth->execute() or die $DBI::errstr;
    $sth_total->execute() or die $DBI::errstr;
    
    my $total_phenotypes = $sth_total->fetchrow_array;

    my @row;
    my $phenotypes = '';
    my $percentage = '';
    my $count      = '';
    while(@row = $sth->fetchrow_array){
        my $pheno_norm = "'". $row[0] ."'"; # !! otherwise R won't work for string array
        $phenotypes  = join(',', $phenotypes, $pheno_norm);
        chomp($phenotypes);
        
        my $percent = sprintf("%.2f",100 * $row[1]/$total_phenotypes);
        $percentage = join(',', $percentage, $percent);
        chomp($percentage);
        
        my $cnt =  "'".$row[1]."\n(". $percent ."%)'";
        $count  = join(',', $count, $cnt);
        chomp($count);
    }
    
    $phenotypes =~ s/.//;
    $percentage =~ s/.//;
    $count      =~ s/.//;

    return ($phenotypes, $percentage, $count, $total_phenotypes);
}
 =cut



1;
